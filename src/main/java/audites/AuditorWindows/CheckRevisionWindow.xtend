package audites.AuditorWindows

import audites.TemplatesWindows.DefaultWindow
import audites.Transformers.RequirementStatusTransformer
import audites.appModel.CheckRevisionAppModel
import audites.domain.Revision
import audites.domain.User
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.GroupPanel
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.List
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import org.uqbar.arena.graphics.Image

class CheckRevisionWindow extends DefaultWindow<CheckRevisionAppModel> {

	new(WindowOwner parent, Revision revision, User user) {
		super(parent, new CheckRevisionAppModel(revision, user))
	}

	override createButtonPanels(Panel actionsPanel) {
		new Button(actionsPanel) => [
			caption = "Cerrar"
			onClick[|
				this.close
			]
		]
	}

	override createWindowToFormPanel(Panel mainPanel) {

		val imagePanel = new Panel(mainPanel)

		new Label(imagePanel) => [
			bindImageToProperty("pathImagen", [ imagePath |
				new Image(imagePath)
			])
		]

		val revisionGeneral = new GroupPanel(mainPanel) => [title = ""]
		new Label(revisionGeneral) => [
			text = this.modelObject.revision.name
			fontSize = 13
		]

		new Label(revisionGeneral) => [
			text = this.modelObject.revisionComment
			height = 200
			width = 400
		]

		val principalPanel = new Panel(mainPanel)
		principalPanel.layout = new HorizontalLayout

		createRequirementPanel(principalPanel)
		createReqDescriptionPanel(principalPanel)
		createStatePanel(principalPanel)

	}

	def createRequirementPanel(Panel panel) {
		val reqPanel = new GroupPanel(panel) => [title = ""]
		new Label(reqPanel) => [
			text = "Requerimientos"
			fontSize = 13
		]

		new List(reqPanel) => [
			value <=> "selectedRequirement"
			(items.bindToProperty("revision.requirements")).adapter = new PropertyAdapter(Revision, "name")
			height = 300
			width = 250
		]
	}

	def createReqDescriptionPanel(Panel panel) {
		val reqDescPanel = new GroupPanel(panel) => [title = ""]

		new Label(reqDescPanel) => [
			text = "Descripción"
			fontSize = 13
		]

		new Label(reqDescPanel) => [
			value <=> "selectedRequirement.descripcion"
			height = 325
			width = 400
		]
	}

	def createStatePanel(Panel panel) {
		val ppanel = new GroupPanel(panel) => [title = ""]

		new Label(ppanel) => [
			text = "Detalles"
			fontSize = 13
		]

		val state = new Panel(ppanel) => [
			layout = new HorizontalLayout
		]

		new Label(state) => [
			text = "Estado: "
			fontSize = 10
		]
		new Label(state) => [
			(background <=> "selectedRequirement.requirementStatus").transformer = new RequirementStatusTransformer
			value <=> "selectedRequirement.requirementStatus"
			fontSize = 10
		]

		val responsableDescription = new Panel(ppanel).layout = new HorizontalLayout
		new Label(responsableDescription) => [
			text = "Comentarios de " + this.modelObject.revision.responsable.name + ":" + "\r\n"
			fontSize = 10
		]

		new Label(ppanel) => [
			value <=> "selectedRequirement.comments"
			height = 257
			width = 400
		]

		val bpanel = new Panel(ppanel)
		new Button(bpanel) => [
			caption = "Ver evidencias"
			enabled <=> "hasEvidence"
			width = 110
			height = 30
			onClick[|
				new AttachtmentWindow(this, this.modelObject.selectedRequirement).open
			]
		]
	}
}
