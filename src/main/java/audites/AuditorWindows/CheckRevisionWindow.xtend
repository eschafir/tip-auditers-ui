package audites.AuditorWindows

import audites.Transformers.RequirementStatusTransformer
import audites.appModel.NewRevisionAppModel
import audites.domain.Revision
import audites.domain.User
import java.awt.Desktop
import java.io.File
import java.nio.file.Paths
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.GroupPanel
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Link
import org.uqbar.arena.widgets.List
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import audites.domain.Evidence

class CheckRevisionWindow extends SimpleWindow<NewRevisionAppModel> {

	new(WindowOwner parent, Revision revision, User user) {
		super(parent, new NewRevisionAppModel(revision, user))
		this.taskDescription = "Estado de revision"
	}

	override protected addActions(Panel actionsPanel) {
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

		val gp = new GroupPanel(mainPanel)
		gp.title = this.modelObject.revision.name

		new Label(gp) => [
			text = this.modelObject.revisionComment
			height = 70
			width = 150
		]

		val principalPanel = new Panel(mainPanel)
		principalPanel.layout = new HorizontalLayout

		createRequirementPanel(principalPanel)
		createReqDescriptionPanel(principalPanel)
		createStatePanel(principalPanel)

	}

	def createRequirementPanel(Panel panel) {
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
			width = 150
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

		new Label(ppanel).text = "Comentarios de " + this.modelObject.revision.responsable.name + ":"
		new Label(ppanel) => [
			value <=> "selectedRequirement.comments"
			height = 150
			width = 150
		]

		validateAttachments(ppanel)
	}

	def validateAttachments(Panel panel) {
		if (this.modelObject.selectedRequirement.evidences.size > 0) {
			new Label(panel).text = "Adjuntos:"
			val desktop = Desktop.desktop

			for (Evidence e : this.modelObject.selectedRequirement.evidences) {
				new Link(panel) => [
					val file = Paths.get(e.path).fileName
					caption = file.toString
					onClick[|
						desktop.open(new File(e.path))
					]
				]
			}
		}
	}
}
