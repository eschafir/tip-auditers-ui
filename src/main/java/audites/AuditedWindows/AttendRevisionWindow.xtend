package audites.AuditedWindows

import audites.Transformers.RequirementStatusTransformer
import audites.appModel.NewRevisionAppModel
import audites.domain.Revision
import audites.domain.User
import audites.repos.RepoRevisions
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
import audites.domain.Evidence

class AttendRevisionWindow extends SimpleWindow<NewRevisionAppModel> {

	new(WindowOwner parent, Revision revision, User user) {
		super(parent, new NewRevisionAppModel(revision, user))
		this.taskDescription = "Atender revision"
	}

	override protected addActions(Panel actionsPanel) {
		new Button(actionsPanel) => [
			caption = "Aceptar"
			onClick[|
				RepoRevisions.instance.update(this.modelObject.revision)
				this.close
			]
		]

		new Button(actionsPanel) => [
			caption = "Atras"
			onClick[|
				this.close
			]
		]
	}

	override protected createFormPanel(Panel mainPanel) {
		this.title = "Auditers"
		this.iconImage = "C:/Users/Esteban/git/tip-auditers-dom/logo.png"

		val ppanel = new Panel(mainPanel)
		ppanel.layout = new HorizontalLayout

		new Label(mainPanel) => [
			text = this.modelObject.revision.name
			fontSize = 15
		]

		val infoPanel = new Panel(mainPanel)
		infoPanel.layout = new HorizontalLayout
		new Label(infoPanel).text = "Autor: "
		new Label(infoPanel).text = this.modelObject.revision.author.name

		val principalPanel = new Panel(mainPanel)
		principalPanel.layout = new HorizontalLayout

		createRequirementsPanel(principalPanel)
		createReqDescriptionPanel(principalPanel)
		createStatePanel(principalPanel)
	}

	def createRequirementsPanel(Panel panel) {
		val reqPanel = new Panel(panel)

		new Label(reqPanel).text = "Requerimientos"
		new List(reqPanel) => [
			value <=> "selectedRequirement"
			(items.bindToProperty("revision.requirements")).adapter = new PropertyAdapter(Revision, "name")
			height = 150
			width = 150
		]
	}

	def createReqDescriptionPanel(Panel panel) {
		val reqDescPanel = new Panel(panel)
		new Label(reqDescPanel).text = "Descripcion"

		new Label(reqDescPanel) => [
			value <=> "selectedRequirement.descripcion"
			height = 200
			width = 200
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

		new Label(ppanel).text = "Comentarios:"
		new TextBox(ppanel) => [
			value <=> "selectedRequirement.comments"
			multiLine = true
			height = 150
			width = 150
		]

		new FileSelector(ppanel) => [
			caption = "Agregar evidencia"
			enabled <=> "hasRequirements"
			value <=> "selectedFile"
		]
		
		new List(ppanel) => [
			//value <=> "selectedRequirement"
			(items.bindToProperty("selectedRequirement.evidences")).adapter = new PropertyAdapter(Evidence, "path")
			height = 150
			width = 150
		]
	}
}
