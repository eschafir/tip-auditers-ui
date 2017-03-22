package audites.application

import org.uqbar.arena.bootstrap.Bootstrap
import audites.domain.User
import audites.repos.RepoUsers

class AuditesBootstrap implements Bootstrap {

	User admin

	def void initUsers() {
		admin = new User() => [
			name = "admin"
			password = "admin"
			email = "esteban.schafir@gmail.com"
		]
		this.createUser(admin)
	}

	def createUser(User user) {
		val repoUsers = RepoUsers.instance
		val listUsers = repoUsers.searchByExample(user)
		if (listUsers.isEmpty) {
			repoUsers.create(user)
			println("User " + user.name + " creado")
		} else {
			val userBD = listUsers.head
			user.id = userBD.id
			repoUsers.update(user)
		}
	}

	override isPending() {
		false
	}

	override run() {
		initUsers
	}

}
