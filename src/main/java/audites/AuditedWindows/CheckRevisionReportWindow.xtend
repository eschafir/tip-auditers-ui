package audites.AuditedWindows

import audites.TemplatesWindows.DefaultWindow
import audites.appModel.GenerateOrEditReportAppModel
import audites.domain.Revision
import audites.domain.User
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.WindowOwner
import audites.domain.Observation
import org.uqbar.arena.widgets.GroupPanel
import org.uqbar.arena.layout.HorizontalLayout

class CheckRevisionReportWindow extends DefaultWindow<GenerateOrEditReportAppModel> {

	new(WindowOwner parent, User user, Revision revision) {
		super(parent, new GenerateOrEditReportAppModel(user, revision))
	}

	override createWindowToFormPanel(Panel panel) {
		new Label(panel) => [
			text = modelObject.revision.report.name
			fontSize = 10
		]

		for (Observation obs : modelObject.revision.report.observations) {
			if (obs.comment != "") {
				val gPanel = new GroupPanel(panel) => [title = ""]
				val reqPanel = new Panel(gPanel).layout = new HorizontalLayout
				new Label(reqPanel) => [
					text = obs.requirement.name
					fontSize = 10
				]

				new Label(gPanel) => [
					text = obs.comment
					fontSize = 8
				]
			}

		}

	}

	override createButtonPanels(Panel panel) {
	}

}
