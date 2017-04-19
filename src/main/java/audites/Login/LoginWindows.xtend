package audites.Login

import audites.MainApplicationWindows
import audites.appModel.LoginAppModel
import audites.appModel.MainApplicationAppModel
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.PasswordField
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner

import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*
import org.uqbar.arena.graphics.Image

class LoginWindows extends SimpleWindow<LoginAppModel> {

	new(WindowOwner parent, LoginAppModel model) {
		super(parent, model)
		this.taskDescription = "Ingrese sus credenciales"
	}

	override protected addActions(Panel arg0) {
		arg0.layout = new HorizontalLayout
		new Button(arg0) => [
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

		new Button(arg0) => [
			caption = "Cancelar"
			width = 65
			onClick [|
				this.close
			]
		]
	}

	override protected createFormPanel(Panel mainPanel) {
		this.title = "Auditers"
		this.iconImage = "C:/Users/Esteban/git/tip-auditers-dom/logo.png"

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
	}

}
