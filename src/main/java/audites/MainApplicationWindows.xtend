package audites

import audites.Login.LoginWindows
import audites.appModel.AdminPanelAppModel
import audites.appModel.AuditorAppModel
import audites.appModel.LoginAppModel
import audites.appModel.MainApplicationAppModel
import audites.domain.Role
import java.util.HashMap
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner

class MainApplicationWindows extends SimpleWindow<MainApplicationAppModel> {

	new(WindowOwner parent, MainApplicationAppModel model) {
		super(parent, model)
		this.taskDescription = "Bienvenido " + this.modelObject.userLoged.name
	}

	override protected addActions(Panel arg0) {
		new Button(arg0) => [
			caption = "Logout"
			onClick[
				this.close
				new LoginWindows(this, new LoginAppModel).open
			]
		]
	}

	override protected createFormPanel(Panel mainPanel) {
		this.title = "Auditers"
		this.iconImage = "C:/Users/Esteban/git/tip-auditers-dom/logo.png"

		val panel = new Panel(mainPanel)
		var botonera = new HashMap

		botonera.put("Administrator", [|
			new Button(panel) => [
				caption = "Administracion"
				onClick[|
					this.close
					new AdminWindow(this, new AdminPanelAppModel(this.modelObject.userLoged)).open
				]
			]
		])
		botonera.put(
			"Auditor",
			[|
				new Button(panel) => [
					caption = "Auditor"
					width = 150
					onClick[|
						this.close
						new AuditorWindow(this, this.modelObject.userLoged).open
					]
				]

			]
		)
		botonera.put(
			"Audited",
			[|
				new Button(panel) => [
					caption = "Revisiones"
					onClick[|
						this.close
						new AuditedWindow(this, new AuditorAppModel(this.modelObject.userLoged)).open
					]

				]
			]
		)

		println(this.modelObject.userLoged.roles)
		for (Role r : this.modelObject.userLoged.roles) {
			botonera.get(r.name).apply
		}
	}
}
