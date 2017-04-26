package audites.Login

import audites.MainApplicationWindows
import audites.TemplatesWindows.DefaultWindow
import audites.appModel.LoginAppModel
import audites.appModel.MainApplicationAppModel
import org.uqbar.arena.graphics.Image
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.PasswordField
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

class LoginWindows extends DefaultWindow<LoginAppModel> {

	new(WindowOwner parent) {
		super(parent, new LoginAppModel)
	}

	override createButtonPanels(Panel panel) {

		new Button(panel) => [
			caption = "Login"
			width = 65
			enabled <=> "passwordIngresed"
			onClick [|
				val model = new MainApplicationAppModel => [
					userLoged = this.modelObject.obtainUser
				]
				this.modelObject.validateUser
				this.modelObject.writeLog(model.userLoged)
				this.close
				new MainApplicationWindows(this, model).open
			]
		]

		new Button(panel) => [
			caption = "Cancelar"
			width = 65
			onClick [|
				this.close
			]
		]
	}

	override createWindowToFormPanel(Panel mainPanel) {

		new Label(mainPanel) => [
			bindImageToProperty("pathImagen", [ imagePath |
				new Image(imagePath)
			])
		]

		crearPanelLogin(mainPanel)
	}

	def crearPanelLogin(Panel owner) {

		new Label(owner).text = "Usuario:"

		new TextBox(owner) => [
			width = 200
			value.bindToProperty("userLoged.username")
		]

		new Label(owner) => [
			text = "Contraseña:"
		]

		new PasswordField(owner) => [
			width = 200
			value.bindToProperty("passwordSubmited")
		]

		val author = new Panel(owner)
		new Label(author) => [
			text = "Created by: Esteban R. Schafir"
			fontSize = 5
		]
	}
}
