package audites.Login

import audites.MainApplicationWindows
import audites.appModel.LoginAppModel
import org.uqbar.arena.layout.ColumnLayout
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.widgets.PasswordField
import org.uqbar.arena.widgets.TextBox
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner
import audites.appModel.MainApplicationAppModel
import static extension org.uqbar.arena.xtend.ArenaXtendExtensions.*

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
				val modelo = new MainApplicationAppModel => [
					userLoged = this.modelObject.obtainUser
				]
				this.modelObject.validateUser
				this.close
				new MainApplicationWindows(this, modelo).open

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
		this.title = "Audites"

		crearPanelLogin(mainPanel)
		crearBotonera(mainPanel)
	}

	def crearPanelLogin(Panel owner) {

		val panelHeader = new Panel(owner)
		panelHeader.layout = new ColumnLayout(2)

		new Label(panelHeader).text = "Usuario:"

		new TextBox(panelHeader) => [
			width = 70
			value.bindToProperty("userLoged.email")
		]

		new Label(panelHeader) => [
			text = "Contraseña:"
		]

		new PasswordField(panelHeader) => [
			width = 70
			value.bindToProperty("passwordSubmited")
		]

	}

	def crearBotonera(Panel owner) {
	}

}
