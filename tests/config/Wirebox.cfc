component extends="coldbox.system.ioc.config.Binder"{

	/**
	* Configure WireBox for integration tests
	*/
	function configure(){

		// The WireBox configuration structure DSL
		wireBox = {
			// Scope registration, automatically register a wirebox injector instance on any CF scope
			// By default it registeres itself on application scope
			scopeRegistration = {
				enabled = true,
				scope   = "application", // server, cluster, session, application
				key		= "wireBox"
			},

			// DSL Namespace registrations
			customDSL = {
				// namespace = "mapping name"
			},

			// Custom Storage Scopes
			customScopes = {
				// annotationName = "mapping name"
			},

			// Package scan locations
			scanLocations = ['modules.cbmongodb','models'],

			// Stop Recursions
			stopRecursions = [],

			// Parent Injector to assign to the configured injector, this must be an object reference
			parentInjector = "",

			// Register all event listeners here, they are created in the specified order
			listeners = [
				// { class="", name="", properties={} }
			]
		};

			
		var configStruct.MongoDB = {
			hosts		= [
							{
								serverName='127.0.0.1',
								serverPort='27017',
								username="unitTestUser",
								password="testing",
								authenticationDB="admin"
							}
							// {
							// 	serverName='ds012345.mongolab.com',
							// 	serverPort='12345',
							// 	username="unitTestUser",
							// 	password="testing",
							// 	authenticationDB="cbmongo_unit_tests"
							// }
						  ],
			db 	= "cbmongo_unit_tests",
			viewTimeout	= "1000"
		};

		//mappings
		map( "jl@cbjavaloader" )
			.to( "cbjavaloader.models.javaloader.JavaLoader" )
			.initArg( name="loadPaths",value=[expandPath('../lib')]);
			
		//configuration
		map("MongoConfig@cbmongodb")
			.to('cbmongodb.models.Mongo.Config')
			.initWith(configStruct.MongoDB)
			.asSingleton();

		//client wrapper
		map("MongoUtil@cbmongodb")
			.to("cbmongodb.models.Mongo.Util")
			.initWith().asSingleton();

		map( "MongoClient@cbmongodb" )
		.to( "cbmongodb.models.Mongo.Client" )
		.initArg(name="MongoConfig",ref="MongoConfig@cbmongodb")
		.asSingleton();

		map("Person")
		.to("cbmongodb.tests.mocks.ActiveEntityMock");
		map("State")
		.to("cbmongodb.tests.mocks.StatesMock");
		map("County")
		.to("cbmongodb.tests.mocks.CountiesMock");
	}

}
