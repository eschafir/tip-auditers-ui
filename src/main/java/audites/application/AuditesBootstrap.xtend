package audites.application

import org.uqbar.arena.bootstrap.Bootstrap
import audites.domain.User
import audites.repos.RepoUsers
import audites.domain.Admin
import audites.domain.Department
import audites.repos.RepoDepartments
import audites.domain.Auditor
import audites.domain.Audited

class AuditesBootstrap implements Bootstrap {

	User admin
	User eschafir
	User dperez
	User rmachado
	User dcullari
	Department seginf
	Department legales
	Department riesgos
	Department auditoria
	Department rrhh

	def void initUsers() {

		admin = new User() => [
			name = "Administrador"
			username = "admin"
			password = "admin"
			email = "admin"
			roles.add(new Admin)
			roles.add(new Auditor)
			roles.add(new Audited)
		]

		eschafir = new User => [
			name = "Esteban Schafir"
			username = "eschafir"
			password = "123"
			email = "esteban.schafir@gmail.com"
			roles.add(new Audited)
			addDepartment(seginf)
		]

		dperez = new User => [
			name = "Diego Perez"
			username = "dperez"
			password = "123"
			email = "esteban.schafir@gmail.com"
			roles.add(new Auditor)
		]

		rmachado = new User => [
			name = "Romina Machado"
			username = "rmachado"
			password = "123"
			email = "esteban.schafir@gmail.com"
			addDepartment(seginf)
			roles.add(new Audited)
		]

		dcullari = new User => [
			name = "Daniel Cullari"
			username = "dcullari"
			password = "123"
			email = "esteban.schafir@gmail.com"
			roles.add(new Audited)
			addDepartment(seginf)
		]

		this.createUser(admin)
		this.createUser(eschafir)
		this.createUser(dperez)
		this.createUser(rmachado)
		this.createUser(dcullari)
		initDepartments
	}

	def void initDepartments() {
		seginf = new Department() => [
			name = "Seguridad Informatica"
			email = "seginf@gmail.com"
			maxAuthority = rmachado
		]

		legales = new Department() => [
			name = "Legales"
			email = "legales@gmail.com"
		]

		riesgos = new Department() => [
			name = "Riesgos"
			email = "riesgos@gmail.com"
		]

		auditoria = new Department() => [
			name = "Auditoria Interna"
			email = "ai@gmail.com"
		]

		rrhh = new Department() => [
			name = "Recursos Humanos"
			email = "rrhh@gmail.com"
		]

		this.createDepartment(seginf)
		this.createDepartment(legales)
		this.createDepartment(riesgos)
		this.createDepartment(auditoria)
		this.createDepartment(rrhh)
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

	def createDepartment(Department department) {
		val repoDep = RepoDepartments.instance
		val listDepartments = repoDep.searchByExample(department)
		if (listDepartments.isEmpty) {
			repoDep.create(department)
			println("Department " + department.name + " creado")
		} else {
			val depBD = listDepartments.head
			department.id = depBD.id
			repoDep.update(department)
		}
	}

	override isPending() {
		false
	}

	override run() {
		initDepartments
		initUsers
	}

}
