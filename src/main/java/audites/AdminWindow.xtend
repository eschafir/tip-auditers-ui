package audites

import audites.appModel.AdminPanelAppModel
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.arena.widgets.Button
import audites.appModel.MainApplicationAppModel

class AdminWindow extends SimpleWindow<AdminPanelAppModel> {

	new(WindowOwner parent, AdminPanelAppModel model) {
		super(parent, model)
		this.title = this.modelObject.userLoged.name
	}

	override protected addActions(Panel actionsPanel) {
		new Button(actionsPanel) => [
			caption = "Atras"
			onClick[|
				this.close
				new MainApplicationWindows(this, new MainApplicationAppModel(this.modelObject.userLoged)).open
			]
		]
	}

	override protected createFormPanel(Panel mainPanel) {

		new Button(mainPanel) => [
			caption = "Agregar usuario"
			onClick [| 
				
			]
		]

	}

}
