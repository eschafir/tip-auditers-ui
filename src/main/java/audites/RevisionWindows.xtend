package audites

import audites.appModel.RevisionAppModel
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.SimpleWindow
import org.uqbar.arena.windows.WindowOwner

class RevisionWindows extends SimpleWindow<RevisionAppModel> {

	new(WindowOwner parent, RevisionAppModel model) {
		super(parent, model)
	}

	override protected addActions(Panel arg0) {
	}

	override protected createFormPanel(Panel mainPanel) {
		this.title = this.modelObject.userLoged.name

	}

}
