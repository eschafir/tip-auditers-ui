package audites.AuditorWindows

import audites.appModel.NewRequirementAppModel
import audites.domain.Revision
import audites.domain.User
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.GroupPanel
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class NewRequirementWindow extends SimpleWindow<NewRequirementAppModel> {

	new(WindowOwner parent, Revision revision, User user) {
		super(parent, new NewRequirementAppModel(revision, user))
	}

	override createContents(Panel mainPanel) {
		createFormPanel(mainPanel)
		addActions(mainPanel)
	}

	override protected addActions(Panel actionsPanel) {
		val buttonsPanel = new Panel(actionsPanel)
		new Button(buttonsPanel) => [
			caption = "Aceptar"
			onClick[|
				this.modelObject.validateRequirement
				this.modelObject.createRequirement
				this.close
			]
		]

		new Button(actionsPanel) => [
			caption = "Cerrar"
			onClick[|
				this.close
			]
		]
	}

	override protected createFormPanel(Panel mainPanel) {
		this.title = "Audites"
		this.iconImage = "C:/Users/Esteban/git/tip-auditers-dom/logo.png"

		val groupPanel = new GroupPanel(mainPanel)
		groupPanel.title = "Datos del requerimiento"

		new Label(groupPanel).text = "Nombre"
		new TextBox(groupPanel) => [
			value <=> "requirement.name"
		]

		new Label(groupPanel).text = "Descripcion"
		new TextBox(groupPanel) => [
			value <=> "requirement.descripcion"
			multiLine = true
			height = 200
			width = 500
		]
	}
}
