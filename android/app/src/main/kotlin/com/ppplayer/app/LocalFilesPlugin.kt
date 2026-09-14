package com.ppplayer.app

import android.content.Context
import android.net.Uri
import androidx.documentfile.provider.DocumentFile
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class LocalFilesPlugin : FlutterPlugin, MethodCallHandler {
    private var context: Context? = null
    private var methodChannel: MethodChannel? = null
    private val coroutineScope = CoroutineScope(Dispatchers.Main)

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        methodChannel = MethodChannel(binding.binaryMessenger, "com.ppplayer.app/local_files")
        methodChannel?.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "canReadContentUri" -> {
                val uriString = call.argument<String>("uri")
                if (uriString == null) {
                    result.error("INVALID", "Missing uri", null)
                    return
                }
                val uri = Uri.parse(uriString)
                val canRead = try {
                    context?.contentResolver?.openInputStream(uri)?.use { true } ?: false
                } catch (e: Exception) {
                    false
                }
                result.success(canRead)
            }
            "listAudioFiles" -> {
                val treeUriString = call.argument<String>("treeUri")
                val recursive = call.argument<Boolean>("recursive") ?: true
                if (treeUriString == null) {
                    result.error("INVALID", "Missing treeUri", null)
                    return
                }

                coroutineScope.launch {
                    val files = withContext(Dispatchers.IO) {
                        val treeUri = Uri.parse(treeUriString)
                        val docTree = try {
                            DocumentFile.fromTreeUri(context!!, treeUri)
                        } catch (e: Exception) {
                            null
                        }
                        val resultList = mutableListOf<String>()
                        if (docTree != null && docTree.isDirectory) {
                            scanDirectory(docTree, recursive, resultList)
                        }
                        resultList
                    }
                    result.success(files)
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun scanDirectory(dir: DocumentFile, recursive: Boolean, resultList: MutableList<String>) {
        val files = dir.listFiles()
        for (file in files) {
            if (file.isDirectory) {
                if (recursive) {
                    scanDirectory(file, recursive, resultList)
                }
            } else {
                val mimeType = file.type ?: ""
                val name = file.name?.lowercase() ?: ""
                if (mimeType.startsWith("audio/") || name.endsWith(".mp3") || name.endsWith(".m4a") || name.endsWith(".flac") || name.endsWith(".wav") || name.endsWith(".aac") || name.endsWith(".ogg")) {
                    resultList.add(file.uri.toString())
                }
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
        context = null
    }
}
