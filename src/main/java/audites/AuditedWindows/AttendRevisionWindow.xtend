package audites.AuditedWindows

import org.uqbar.arena.windows.SimpleWindow
import audites.appModel.CheckOrAttendRevisionAppModel
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.arena.widgets.Panel
import audites.domain.Revision
import audites.domain.User
import org.uqbar.arena.widgets.Label

class AttendRevisionWindow extends SimpleWindow<CheckOrAttendRevisionAppModel> {

	new(WindowOwner parent, Revision revision, User user) {
		super(parent, new CheckOrAttendRevisionAppModel(revision, user))
	}

	override protected addActions(Panel actionsPanel) {
	}

	override protected createFormPanel(Panel mainPanel) {
		new Label(mainPanel).text = this.modelObject.revision.author.name
	}

}
