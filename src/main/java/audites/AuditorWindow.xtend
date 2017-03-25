package audites

import audites.appModel.AuditorAppModel
import audites.appModel.MainApplicationAppModel
import audites.appModel.NewRevisionAppModel
import org.uqbar.arena.layout.HorizontalLayout
import org.uqbar.arena.widgets.Button
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner
import audites.AuditorWindows.NewRevisionWindow

class AuditorWindow extends SimpleWindow<AuditorAppModel> {

	new(WindowOwner parent, AuditorAppModel model) {
		super(parent, model)
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
		val panelButtons = new Panel(mainPanel)
		panelButtons.layout = new HorizontalLayout

		new Button(panelButtons) => [
			caption = "Nueva revision"
			onClick[|
				this.close
				new NewRevisionWindow(this, new NewRevisionAppModel(this.modelObject.userLoged)).open

			]
		]

//		new List<Revision>(mainPanel) => [
//			value.bindToProperty("revisionSelected")
//			(items.bindToProperty("userLoged.auditorRevisions")).adapter = new PropertyAdapter(Revision, "name")
//			height = 150
//		]
	}

}
