package audites.AuditorWindows

import audites.TemplatesWindows.DefaultWindow
import audites.appModel.NewRequirementAppModel
import audites.domain.Requirement
import audites.domain.Revision
import audites.domain.User
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class EditRequirementWindow extends DefaultWindow<NewRequirementAppModel> {

	new(WindowOwner parent, Revision model, Requirement requirement, User user) {
		super(parent, new NewRequirementAppModel(model, requirement, user))
	}

	override createButtonPanels(Panel actionsPanel) {
		new Button(actionsPanel) => [
			caption = "Aceptar"
			onClick[|this.close]
		]
	}

	override createWindowToFormPanel(Panel mainPanel) {

		new TextBox(mainPanel) => [
			value <=> "reqName"
			width = 200
		]

		new TextBox(mainPanel) => [
			value <=> "reqDescription"
			multiLine = true
			width = 500
			height = 400
		]

	}
}
