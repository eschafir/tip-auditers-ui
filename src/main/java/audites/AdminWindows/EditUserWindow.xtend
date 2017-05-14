package audites.AdminWindows

import audites.domain.User
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.arena.widgets.Button
import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class EditUserWindow extends NewOrEditUserWindow {

	new(WindowOwner parent, User user, User toEdit) {
		super(parent, user, toEdit)
	}

	override titleLabel(Panel panel) {
		new Label(panel) => [
			text = "Editar Usuario"
			fontSize = 15
		]
	}

	override passwordLabel(Panel panel) {
	}

	override cancelCreateOrEdit() {
		modelObject.cancelEdit()
	}

	override statusButton(Panel panel) {
		if (modelObject.user.enabled) {
			new Button(panel) => [
				caption = "Deshabilitar"
				fontSize = 10
				width = 140
				height = 40
				visible <=> "userIsEnabled"
				onClick[|
					modelObject.changeUserStatus
					this.close
					new EditUserWindow(this, modelObject.userLoged, modelObject.user).open
				]
			]
		} else {
			new Button(panel) => [
				caption = "Habilitar"
				fontSize = 10
				width = 140
				height = 40
				visible <=> "userIsDisabled"
				onClick[|
					modelObject.changeUserStatus
					this.close
					new EditUserWindow(this, modelObject.userLoged, modelObject.user).open
				]
			]
		}
	}
}
