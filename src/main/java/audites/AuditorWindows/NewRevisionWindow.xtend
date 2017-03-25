package audites.AuditorWindows

import audites.AuditorWindow
import audites.appModel.AuditorAppModel
import audites.appModel.NewRevisionAppModel
import audites.domain.Department
import org.uqbar.arena.bindings.PropertyAdapter
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.Selector
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner

class NewRevisionWindow extends SimpleWindow<NewRevisionAppModel> {

	new(WindowOwner parent, NewRevisionAppModel model) {
		super(parent, model)
		this.title = "Nueva revision"
	}

	override protected addActions(Panel actionsPanel) {
		new Button(actionsPanel) => [
			caption = "Atras"
			onClick[|
				this.close
				new AuditorWindow(this, new AuditorAppModel(this.modelObject.userLoged)).open
			]
		]
	}

	override protected createFormPanel(Panel mainPanel) {
		val principalPanel = new Panel(mainPanel)
		principalPanel.layout = new ColumnLayout(3)

		createRevisionPanel(principalPanel)

	}

	def createRevisionPanel(Panel panel) {
		val revisionPanel = new Panel(panel)
		//revisionPanel.width = 200

		new Label(revisionPanel) => [
			text = "Revisiones"
			fontSize = 15
		]

		val nameRevision = new Panel(revisionPanel)
		nameRevision.layout = new HorizontalLayout

		new Label(nameRevision).text = "Nombre de revision"
		new TextBox(nameRevision) => [
			value.bindToProperty("revision.name")
			width = 200
		]

		val departmentRevision = new Panel(revisionPanel)
		departmentRevision.layout = new HorizontalLayout

		new Label(departmentRevision).text = "Departamento"
		new Selector(departmentRevision) => [
			allowNull(false)
			value.bindToProperty("selectedDepartment")
			(items.bindToProperty("departments")).adapter = new PropertyAdapter(Department, "name")
		]

	}

}
