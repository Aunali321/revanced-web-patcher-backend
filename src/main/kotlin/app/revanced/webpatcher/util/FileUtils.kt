package app.revanced.webpatcher.util

import app.revanced.webpatcher.model.UploadedFile
import io.ktor.http.content.PartData
import io.ktor.utils.io.core.readBytes
import java.io.File
import java.nio.file.Files
import java.nio.file.Path
import java.util.*

/**
 * File management utilities to eliminate code duplication.
 * Consolidates file handling patterns used across PatchService and PatchRoutes.
 */

object FileUtils {

    /**
     * Save an uploaded file to a temporary location with proper extension.
     * Consolidates duplicate file saving logic from PatchRoutes.kt and PatchService.kt.
     */
    fun saveUpload(part: PartData.FileItem): File {
        val originalName = part.originalFileName ?: "upload.bin"
        val extension = originalName.substringAfterLast('.', "").lowercase().let {
            if (it.isBlank()) "" else ".$it"
        }
        val tempFile = Files.createTempFile("web-patcher-upload-", extension).toFile()
        tempFile.writeBytes(part.provider().readBytes())
        return tempFile
    }

    /**
     * Create a temporary workspace directory for patching operations.
     * Replaces duplicate workspace creation logic.
     */
    fun createWorkspace(prefix: String = "web-patcher-"): File {
        val workspaceId = UUID.randomUUID().toString().substring(0, 8)
        return Files.createTempDirectory("${prefix}${workspaceId}-").toFile()
    }

    /**
     * Create patcher working directory within workspace.
     * Standardizes patcher temp directory creation.
     */
    fun createPatcherTempDir(workspace: File): File {
        return workspace.resolve("patcher-temp").also { it.mkdirs() }
    }

    /**
     * Copy uploaded APK to workspace with standardized naming.
     * Replaces duplicate APK copying logic.
     */
    fun copyApkToWorkspace(apk: UploadedFile, workspace: File): File {
        return apk.file.copyTo(workspace.resolve(apk.originalName ?: "uploaded.apk"), overwrite = true)
    }

    /**
     * Copy patch bundles to workspace with standardized naming.
     * Replaces duplicate patch copying logic.
     */
    fun copyPatchesToWorkspace(patches: List<UploadedFile>, workspace: File): List<File> {
        return patches.mapIndexed { index, uploadedFile ->
            val name = uploadedFile.originalName?.ifBlank { "patch-${index + 1}.rvp" }
                ?: "patch-${index + 1}.rvp"
            uploadedFile.file.copyTo(workspace.resolve(name), overwrite = true)
        }
    }

    /**
     * Clean up workspace and all contained files.
     * Standardizes workspace cleanup across services.
     */
    fun cleanupWorkspace(workspace: File) {
        try {
            workspace.deleteRecursively()
        } catch (e: Exception) {
            // Log warning but don't fail - cleanup is best effort
            println("Warning: Failed to cleanup workspace ${workspace.absolutePath}: ${e.message}")
        }
    }

    /**
     * Create output file name for patched APK.
     * Standardizes output file naming.
     */
    fun createOutputFileName(originalApkName: String): String {
        val nameWithoutExtension = originalApkName.substringBeforeLast('.')
        val extension = originalApkName.substringAfterLast('.')
        return "${nameWithoutExtension}-patched.${extension}"
    }
}