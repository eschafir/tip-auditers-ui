package audites.AuditorWindows

import audites.domain.Requirement
import audites.domain.Revision
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.GroupPanel
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import audites.appModel.NewRequirementAppModel

class NewRequirementWindow extends SimpleWindow<NewRequirementAppModel> {

	new(WindowOwner parent, Requirement requirement, Revision revision) {
		super(parent, new NewRequirementAppModel(requirement, revision))
	}

	override protected addActions(Panel actionsPanel) {

		new Button(actionsPanel) => [
			caption = "Aceptar"
			onClick[|
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
		this.iconImage = "C:/Users/Esteban/git/tip-audites-dom/logo.png"

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
			width = 200
		]

	}

}
