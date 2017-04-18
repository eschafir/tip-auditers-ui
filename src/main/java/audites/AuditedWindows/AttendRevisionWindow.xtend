package audites.AuditedWindows

import audites.AuditedWindow
import audites.Transformers.RequirementStatusTransformer
import audites.appModel.AttendRevisionAppModel
import audites.appModel.AuditedAppModel
import audites.domain.Evidence
import audites.domain.Revision
import audites.domain.User
import audites.repos.RepoRevisions
import javax.swing.JOptionPane
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.FileSelector
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.List
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class AttendRevisionWindow extends SimpleWindow<AttendRevisionAppModel> {

	new(WindowOwner parent, Revision revision, User user) {
		super(parent, new AttendRevisionAppModel(revision, user))
		this.taskDescription = "Atender revision"
	}

	override protected addActions(Panel actionsPanel) {
		new Button(actionsPanel) =>
			[
				caption = "Aceptar"
				onClick[|
					RepoRevisions.instance.update(this.modelObject.revision)
					if (this.modelObject.revisionCompletedAndUserIsNotMaxAuthority) {
						openConfirmationDialog()
					}

					this.close
					new AuditedWindow(this, new AuditedAppModel(this.modelObject.userLoged)).open
				]
			]

		new Button(actionsPanel) => [
			caption = "Atras"
			onClick[|
				this.close
				new AuditedWindow(this, new AuditedAppModel(this.modelObject.userLoged)).open
			]
		]
	}

	override protected createFormPanel(Panel mainPanel) {
		this.title = "Auditers"
		this.iconImage = "C:/Users/Esteban/git/tip-auditers-dom/logo.png"

		new Label(mainPanel) => [
			text = this.modelObject.revision.name
			fontSize = 15
		]

		val principalPanel = new Panel(mainPanel)
		principalPanel.layout = new HorizontalLayout

		createRequirementsPanel(principalPanel)
		createReqDescriptionPanel(principalPanel)
		createStatePanel(principalPanel)

		val infoPanel = new Panel(mainPanel)
		infoPanel.layout = new HorizontalLayout
		new Label(infoPanel).text = "Autor: "
		new Label(infoPanel).text = this.modelObject.revision.author.name
	}

	def createRequirementsPanel(Panel panel) {
		val reqPanel = new Panel(panel)

		new Label(reqPanel).text = "Requerimientos"
		new List(reqPanel) => [
			value <=> "selectedRequirement"
			(items.bindToProperty("revision.requirements")).adapter = new PropertyAdapter(Revision, "name")
			height = 150
			width = 200
		]
	}

	def createReqDescriptionPanel(Panel panel) {
		val reqDescPanel = new Panel(panel)
		new Label(reqDescPanel).text = "Descripcion"

		new Label(reqDescPanel) => [
			value <=> "selectedRequirement.descripcion"
			height = 200
			width = 500
		]
	}

	def createStatePanel(Panel panel) {
		val ppanel = new Panel(panel)
		val state = new Panel(ppanel) => [
			layout = new HorizontalLayout
		]

		new Label(state).text = "Estado: "
		new Label(state) => [
			(background <=> "selectedRequirement.requirementStatus").transformer = new RequirementStatusTransformer
			value <=> "selectedRequirement.requirementStatus"
		]
		new Button(state) => [
			caption = "<<"
			height = 20
			onClick[|
				this.modelObject.changeRequirmentStatus
			]
		]

		new Label(ppanel).text = "Comentarios:"
		new TextBox(ppanel) => [
			value <=> "selectedRequirement.comments"
			multiLine = true
			height = 150
			width = 500
		]

		new FileSelector(ppanel) => [
			caption = "Agregar evidencia"
			enabled <=> "hasRequirements"
			value <=> "selectedFile"
		]

		new List(ppanel) => [
			// value <=> "selectedRequirement"
			(items.bindToProperty("selectedRequirement.evidences")).adapter = new PropertyAdapter(Evidence, "path")
			height = 30
			width = 150
		]
	}

	protected def openConfirmationDialog() {
		val dialogButton = JOptionPane.YES_NO_OPTION;
		val dialogAnswer = JOptionPane.showConfirmDialog(null,
			"La revision '" + this.modelObject.revision.name + "' fue completada. Se derivara a " +
				this.modelObject.revision.responsable.maxAuthority.name + " para su revision." + "\r\n" +
				"¿Desea continuar?", "question", dialogButton);

			if (dialogAnswer == JOptionPane.YES_OPTION) {
				this.modelObject.deriveToMaxAuthority
			}
		}
	}
	