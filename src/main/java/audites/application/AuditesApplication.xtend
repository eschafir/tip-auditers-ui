package audites.application

import audites.Login.LoginWindows
import audites.appModel.LoginAppModel
import org.uqbar.arena.Application

class AuditesApplication extends Application {

	new(AuditesBootstrap bootstrap) {
		super(bootstrap)
	}

	override protected createMainWindow() {
		val model = new LoginAppModel()
		new LoginWindows(this, model)

	}

	def static main(String[] args) {

		new AuditesApplication(new AuditesBootstrap).start()
	}

}
