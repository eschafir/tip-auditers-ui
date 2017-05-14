package audites.AuditorWindows

import audites.TemplatesWindows.DefaultWindow
import audites.appModel.GenerateReportAppModel
import audites.domain.Revision
import audites.domain.User
import org.uqbar.arena.widgets.Panel
import org.uqbar.arena.windows.WindowOwner
import org.uqbar.arena.widgets.Label
import org.uqbar.arena.graphics.Image

class GenerateReportWindow extends DefaultWindow<GenerateReportAppModel> {

	new(WindowOwner parent, User user, Revision revision) {
		super(parent, new GenerateReportAppModel(user, revision))
	}

	override createWindowToFormPanel(Panel panel) {
		val imagePanel = new Panel(panel)

		new Label(imagePanel) => [
			bindImageToProperty("pathImagen", [ imagePath |
				new Image(imagePath)
			])
		]
	}

	override createButtonPanels(Panel panel) {
	}

}
