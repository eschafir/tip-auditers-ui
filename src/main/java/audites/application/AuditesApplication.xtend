package audites.application

import org.uqbar.arena.Application
import audites.appModel.LoginAppModel
import audites.Login.LoginWindows
import audites.domain.User

class AuditesApplication extends Application {

	override protected createMainWindow() {
		val model = new LoginAppModel => [
			userLoged = new User()
		]
		new LoginWindows(this, model)
	}
	
	def static main(String[] args) {

		new AuditesApplication().start
	}

}
