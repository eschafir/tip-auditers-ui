package audites.AuditorWindows

import audites.appModel.NewRevisionAppModel
import audites.domain.Department
import audites.domain.Revision
import org.uqbar.arena.bindings.DateTransformer
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.GroupPanel
import org.uqbar.arena.widgets.List
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.Selector
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class EditRevisionWindow extends NewRevisionWindow {

	new(WindowOwner parent, Revision revision) {
		super(parent, new NewRevisionAppModel(revision))
	}

	override createButtonPanels(Panel actionsPanel) {
		new Button(actionsPanel) => [
			caption = "Cerrar"
			onClick[|
				this.modelObject.validateRequirements
				this.close
			]
		]
	}

	override createWindowToFormPanel(Panel mainPanel) {
		revisionName(mainPanel)
		revisionDepartment(mainPanel)
		revisionDescription(mainPanel)
		revisionEndDate(mainPanel)
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

	protected def revisionDepartment(Panel mainPanel) {
		val revisionDepartmentPanel = new GroupPanel(mainPanel) => [title = "Departamento"]
		new Selector(revisionDepartmentPanel) => [
			width = 185
			allowNull(false)
			value <=> "editRevisionDepartment"
			(items.bindToProperty("departments")).adapter = new PropertyAdapter(Department, "name")
		]

	}

	protected def revisionEndDate(Panel mainPanel) {
		val revisionName = new GroupPanel(mainPanel) => [title = "Fecha de finalizacion"]
		new TextBox(revisionName) => [
			value.bindToProperty("revisionEndDate").transformer = new DateTransformer
		]
	}

}
