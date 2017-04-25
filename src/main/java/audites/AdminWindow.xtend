package audites

import audites.TemplatesWindows.DefaultWindow
import audites.appModel.AdminPanelAppModel
import audites.appModel.MainApplicationAppModel
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.WindowOwner

class AdminWindow extends DefaultWindow<AdminPanelAppModel> {

	new(WindowOwner parent, AdminPanelAppModel model) {
		super(parent, model)
		this.title = this.modelObject.userLoged.name
	}

	override createButtonPanels(Panel actionsPanel) {
		new Button(actionsPanel) => [
			caption = "Atras"
			onClick[|
				this.close
				new MainApplicationWindows(this, new MainApplicationAppModel(this.modelObject.userLoged)).open
			]
		]
	}

	override createWindowToFormPanel(Panel mainPanel) {

		new Button(mainPanel) => [
			caption = "Agregar usuario"
			onClick [| 
				
			]
		]

		new Button(mainPanel) => [
			caption = "Eliminar usuario"
			onClick [| 
				
			]
		]
	}
}
