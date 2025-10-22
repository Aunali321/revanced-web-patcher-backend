pluginManagement {
    repositories {
        gradlePluginPortal()
        mavenCentral()
        google()
    }
}

dependencyResolutionManagement {
    repositories {
        mavenCentral()
        google()
        val githubActor = providers.gradleProperty("gpr.user").orNull ?: System.getenv("GITHUB_ACTOR")
        val githubToken = providers.gradleProperty("gpr.key").orNull ?: System.getenv("GITHUB_TOKEN")
        maven {
            url = uri("https://maven.pkg.github.com/revanced/registry")
            credentials {
                username = githubActor
                password = githubToken
            }
        }
    }
}

rootProject.name = "web-patcher-service"
