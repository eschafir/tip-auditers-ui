package audites.AuditorWindows

import org.uqbar.arena.windows.SimpleWindow
import audites.domain.Requirement
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.arena.widgets.Panel
import audites.appModel.NewRequirementAppModel
import audites.domain.Revision

class EditRequirementWindow extends SimpleWindow<NewRequirementAppModel> {

	new(WindowOwner parent, Requirement model, Revision revision) {
		super(parent, new NewRequirementAppModel(model, revision))
		this.taskDescription = this.modelObject.requirement.name
	}

	override protected addActions(Panel actionsPanel) {
	}

	override protected createFormPanel(Panel mainPanel) {
		this.title = "Audites"
		this.iconImage = "C:/Users/Esteban/git/tip-audites-dom/logo.png"
	}

}
