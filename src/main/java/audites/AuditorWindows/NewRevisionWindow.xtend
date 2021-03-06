package audites.AuditorWindows

import audites.AuditorWindow
import audites.TemplatesWindows.DefaultWindow
import audites.appModel.NewRevisionAppModel
import audites.domain.Department
import audites.domain.Requirement
import audites.repos.RepoRevisions
import org.uqbar.arena.bindings.DateTransformer
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.layout.VerticalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.GroupPanel
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.List
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.Selector
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class NewRevisionWindow extends DefaultWindow<NewRevisionAppModel> {

	new(WindowOwner parent, NewRevisionAppModel model) {
		super(parent, model)
	}

	override createButtonPanels(Panel actionsPanel) {

		new Button(actionsPanel) => [
			caption = "Aceptar"
			setAsDefault
			onClick[|
				this.modelObject.validateRevision
				RepoRevisions.instance.update(this.modelObject.revision)
				this.modelObject.logAndNotify
				this.close
				new AuditorWindow(this, this.modelObject.userLoged).open
			]
		]

		new Button(actionsPanel) => [
			caption = "Atras"
			onClick[|
				this.close
				new AuditorWindow(this, this.modelObject.userLoged).open
			]
		]
	}

	override createWindowToFormPanel(Panel mainPanel) {
		val principalPanel = new Panel(mainPanel)
		principalPanel.layout = new HorizontalLayout

		createRevisionPanel(principalPanel)
		createRequirementsPanel(principalPanel)

	}

	def createRevisionPanel(Panel panel) {
		val revisionPanel = new GroupPanel(panel)
		revisionPanel.title = "Nueva revision"

		val nameRevision = new Panel(revisionPanel)
		nameRevision.layout = new VerticalLayout

		new Label(nameRevision).text = "Nombre"
		new TextBox(nameRevision) => [
			value <=> "revision.name"
			width = 500
		]

		val departmentRevision = new Panel(revisionPanel)
		departmentRevision.layout = new VerticalLayout

		new Label(departmentRevision).text = "Departamento"
		new Selector(departmentRevision) => [
			width = 185
			allowNull(false)
			value <=> "selectedDepartment"
			(items.bindToProperty("departments")).adapter = new PropertyAdapter(Department, "name")
		]

		val description = new Panel(revisionPanel)
		new Label(description).text = "Comentarios"
		new TextBox(description) => [
			multiLine = true
			height = 200
			width = 500
			value <=> "revision.description"
		]

		val dates = new Panel(revisionPanel)
		new Label(dates).text = "Fecha limite"
		new TextBox(dates) => [
			value.bindToProperty("revision.endDate").transformer = new DateTransformer
		]
	}

	def createRequirementsPanel(Panel panel) {
		val reqPanel = new GroupPanel(panel)
		reqPanel.title = "Requerimientos"
		reqPanel.width = 200

		new Label(reqPanel) => [
			value <=> "revision.name"
		]

		new List<Requirement>(reqPanel) => [
			value <=> "selectedRequirement"
			(items.bindToProperty("revision.requirements")).adapter = new PropertyAdapter(Requirement, "name")
			height = 255
			width = 230
		]

		new Button(reqPanel) => [
			caption = "Agregar..."
			enabled <=> "departmentIngresed"
			onClick[|
				modelObject.createRevison
				new NewRequirementWindow(this, this.modelObject.revision, this.modelObject.userLoged).open
			]
		]

		new Button(reqPanel) => [
			caption = "Eliminar"
			enabled <=> "hasRequirements"
			onClick[|
				if (this.modelObject.selectedRequirement != null) {
					this.modelObject.deleteRequirement
				}
			]
		]

		new Button(reqPanel) =>
			[
				caption = "Editar..."
				enabled <=> "hasRequirements"
				onClick[|
					new EditRequirementWindow(this, this.modelObject.revision, this.modelObject.selectedRequirement,
						this.modelObject.userLoged).open
				]
			]
	}
}
