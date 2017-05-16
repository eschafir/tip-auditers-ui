package audites.AuditedWindows

import audites.TemplatesWindows.DefaultWindow
import audites.appModel.GenerateOrEditReportAppModel
import audites.domain.Revision
import audites.domain.User
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.WindowOwner

class CheckRevisionReportWindow extends DefaultWindow<GenerateOrEditReportAppModel> {

	new(WindowOwner parent, User user, Revision revision) {
		super(parent, new GenerateOrEditReportAppModel(user, revision))
	}

	override createWindowToFormPanel(Panel panel) {
		new Label(panel) => [
			text = modelObject.revision.report.name
			fontSize = 10
		]
		new Label(panel).text = modelObject.revision.report.observations
	}

	override createButtonPanels(Panel panel) {
	}

}
