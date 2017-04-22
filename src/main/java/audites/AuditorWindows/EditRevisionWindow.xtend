package audites.AuditorWindows

import audites.appModel.NewRevisionAppModel
import audites.domain.Revision
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.GroupPanel
import org.uqbar.arena.widgets.List
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class EditRevisionWindow extends NewRevisionWindow {

	new(WindowOwner parent, Revision revision) {
		super(parent, new NewRevisionAppModel(revision))
		this.taskDescription = "Edita la revision " + this.modelObject.revisionName
	}

	override protected addActions(Panel actionsPanel) {

		new Button(actionsPanel) => [
			caption = "Cerrar"
			onClick[|
				this.modelObject.validateRequirements
				this.close
			]
		]
	}

	override protected createFormPanel(Panel mainPanel) {
		this.title = "Audites"
		this.iconImage = "C:/Users/Esteban/git/tip-auditers-dom/logo.png"

		revisionName(mainPanel)
		revisionDescription(mainPanel)
		revisionRequirements(mainPanel)

	}

	protected def revisionRequirements(Panel mainPanel) {
		val groupPanel = new GroupPanel(mainPanel) => [
			title = "Requerimientos"
		]

		new List(groupPanel) => [
			value <=> "selectedRequirement"
			(items.bindToProperty("revision.requirements")).adapter = new PropertyAdapter(Revision, "name")
			height = 150
			width = 250
		]

		val options = new Panel(groupPanel).layout = new HorizontalLayout

		new Button(options) => [
			caption = "Agregar"
			onClick[|
				new NewRequirementWindow(this, this.modelObject.revision, this.modelObject.userLoged).open
			]
		]

		new Button(options) =>
			[
				caption = "Editar"
				enabled <=> "hasRequirements"
				onClick[|
					new EditRequirementWindow(this, this.modelObject.revision, this.modelObject.selectedRequirement,
						this.modelObject.userLoged).open
				]
			]

		new Button(options) => [
			caption = "Eliminar"
			enabled <=> "hasRequirements"
			onClick[|
				if (this.modelObject.selectedRequirement != null) {
					this.modelObject.deleteRequirement
				}
			]
		]
	}

	protected def revisionDescription(Panel mainPanel) {
		val revisionDescription = new GroupPanel(mainPanel) => [title = "Descripcion"]
		new TextBox(revisionDescription) => [
			value <=> "revisionComment"
			multiLine = true
			height = 150
			width = 500
		]
	}

	protected def revisionName(Panel mainPanel) {
		val revisionName = new GroupPanel(mainPanel) => [title = "Nombre de la revision"]
		new TextBox(revisionName) => [
			value <=> "revisionName"
			width = 500
		]
	}

}
