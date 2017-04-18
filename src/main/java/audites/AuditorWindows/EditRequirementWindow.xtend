package audites.AuditorWindows

import org.uqbar.arena.windows.SimpleWindow
import audites.domain.Requirement
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.arena.widgets.Panel
import audites.appModel.NewRequirementAppModel
import audites.domain.Revision
import audites.domain.User
import org.uqbar.arena.widgets.TextBox
import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import org.uqbar.arena.widgets.Button

class EditRequirementWindow extends SimpleWindow<NewRequirementAppModel> {

	new(WindowOwner parent, Revision model, Requirement requirement, User user) {
		super(parent, new NewRequirementAppModel(model, requirement, user))
		this.taskDescription = "Editar el requerimiento" + this.modelObject.reqName
	}

	override protected addActions(Panel actionsPanel) {
		new Button(actionsPanel) => [
			caption = "Aceptar"
			onClick[|this.close]
		]
	}

	override protected createFormPanel(Panel mainPanel) {
		this.title = "Audites"
		this.iconImage = "C:/Users/Esteban/git/tip-auditers-dom/logo.png"

		new TextBox(mainPanel) => [
			value <=> "reqName"
			width = 200
		]

		new TextBox(mainPanel) => [
			value <=> "reqDescription"
			multiLine = true
			width = 200
			height = 500
		]

	}

}
