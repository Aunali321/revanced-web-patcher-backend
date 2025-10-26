package app.revanced.webpatcher

import app.revanced.library.PatchesOptions
import kotlinx.serialization.json.Json
import kotlinx.serialization.serializer

private val json = Json {
    ignoreUnknownKeys = true
    isLenient = true
}

object OptionParser {
    fun parse(input: String?): PatchesOptions {
        if (input.isNullOrBlank()) return emptyMap()

        return runCatching {
            json.decodeFromString<PatchesOptions>(input)
        }.getOrElse { throwable ->
            throw IllegalArgumentException("Unable to parse options JSON: ${throwable.message}", throwable)
        }
    }

    fun parseSelectedPatches(input: String?): Set<String> {
        if (input.isNullOrBlank()) return emptySet()

        return runCatching {
            json.decodeFromString<Set<String>>(input)
        }.getOrElse { throwable ->
            throw IllegalArgumentException("Unable to parse selected patches JSON: ${throwable.message}", throwable)
        }
    }
}
