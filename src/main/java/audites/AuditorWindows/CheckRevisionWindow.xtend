package audites.AuditorWindows

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
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class CheckRevisionWindow extends SimpleWindow<CheckRevisionAppModel> {

	new(WindowOwner parent, Revision revision, User user) {
		super(parent, new CheckRevisionAppModel(revision, user))
	}

	override protected addActions(Panel actionsPanel) {
		val buttonPanel = new Panel(actionsPanel)
		new Button(buttonPanel) => [
			caption = "Cerrar"
			onClick[|
				this.close
			]
		]
	}

	override protected createFormPanel(Panel mainPanel) {
		this.title = "Auditers"
		this.iconImage = "C:/Users/Esteban/git/tip-auditers-dom/logo.png"

		val revisionGeneral = new GroupPanel(mainPanel)
		revisionGeneral.title = this.modelObject.revision.name

		new Label(revisionGeneral) => [
			text = this.modelObject.revisionComment
			height = 200
			width = 500
		]

		val principalPanel = new Panel(mainPanel)
		principalPanel.layout = new HorizontalLayout

		createRequirementPanel(principalPanel)
		createReqDescriptionPanel(principalPanel)
		createStatePanel(principalPanel)

	}

	def createRequirementPanel(Panel panel) {
		val reqPanel = new GroupPanel(panel) => [title = "Requerimientos"]

		new List(reqPanel) => [
			value <=> "selectedRequirement"
			(items.bindToProperty("revision.requirements")).adapter = new PropertyAdapter(Revision, "name")
			height = 300
			width = 250
		]
	}

	def createReqDescriptionPanel(Panel panel) {
		val reqDescPanel = new GroupPanel(panel) => [title = "Descripcion"]

		new Label(reqDescPanel) => [
			value <=> "selectedRequirement.descripcion"
			height = 325
			width = 500
		]
	}

	def createStatePanel(Panel panel) {
		val ppanel = new GroupPanel(panel) => [title = "Detalles"]
		val state = new Panel(ppanel) => [
			layout = new HorizontalLayout
		]

		new Label(state).text = "Estado: "
		new Label(state) => [
			(background <=> "selectedRequirement.requirementStatus").transformer = new RequirementStatusTransformer
			value <=> "selectedRequirement.requirementStatus"
		]

		val responsableDescription = new Panel(ppanel) => [layout = new HorizontalLayout]
		new Label(responsableDescription).text = "Comentarios de " + this.modelObject.revision.responsable.name + ":"
		new Label(responsableDescription) => [
			value <=> "selectedRequirement.comments"
			height = 257
			width = 400
		]

		new Button(ppanel) => [
			caption = "Ver evidencias"
			enabled <=> "hasEvidence"
			onClick[|
				new AttachtmentWindow(this, this.modelObject.selectedRequirement).open
			]
		]
	}

	override createContents(Panel mainPanel) {
		createFormPanel(mainPanel)
		addActions(mainPanel)
	}
}
