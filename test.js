<!DOCTYPE html>
<html lang="en">
  <head>
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"
    />
    <script>
        window.onerror = function(msg, url, line, col, error) {
            if (window.NativeLog) {
                window.NativeLog.postMessage("JS ERROR: " + msg + " at " + line + ":" + col);
            }
        };
        const origConsoleError = console.error;
        console.error = function() {
            if (window.NativeLog) {
                window.NativeLog.postMessage("JS CONSOLE ERROR: " + Array.from(arguments).join(" "));
            }
            origConsoleError.apply(console, arguments);
        };
        const origConsoleLog = console.log;
        console.log = function() {
            if (window.NativeLog) {
                window.NativeLog.postMessage("JS CONSOLE LOG: " + Array.from(arguments).join(" "));
            }
            origConsoleLog.apply(console, arguments);
        };
    </script>
    <style>
      html {
        width: 100%;
        height: 100%;
        background-color: black;
        pointer-events: auto;
      }

      body {
        margin: 0;
        width: 100%;
        height: 100%;
        background-color: black;
        pointer-events: inherit;
      }

      .embed-container iframe,
      .embed-container object,
      .embed-container embed {
        position: absolute;
        top: 0;
        left: 0;
        width: 100% !important;
        height: 100% !important;
        pointer-events: inherit;
      }
    </style>
    <title>Youtube Player</title>
  </head>

  <body>
    <div class="embed-container">
      <div id="id"></div>
    </div>

    <script>
      var tag = document.createElement("script");
      tag.src = "https://www.youtube.com/iframe_api";
      var firstScriptTag = document.getElementsByTagName("script")[0];
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

      window.onerror = function(msg, url, line, col, error) {
        if (window.NativeLog) {
          window.NativeLog.postMessage("JS ERROR: " + msg + " at " + line + ":" + col);
        }
      };

      console.error = function() {
        if (window.NativeLog) {
          window.NativeLog.postMessage("JS CONSOLE ERROR: " + Array.from(arguments).join(" "));
        }
      };

      if (window.NativeLog) {
          window.NativeLog.postMessage("Before onYouTubeIframeAPIReady definition!");
      }

      var platform = "mac";
      var host = "youtube.com";
      var player;
      var timerId;

      function onYouTubeIframeAPIReady() {
        if (window.NativeLog) window.NativeLog.postMessage("[YT] Player created");
        player = new YT.Player("id", {
          host: host,
          playerVars: {},
          events: {
            onReady: function (event) {
              if (window.NativeLog) window.NativeLog.postMessage("[YT] onReady entered");
              try {
                if (window.NativeLog) window.NativeLog.postMessage("[YT] fullscreen handler entered");
                handleFullScreenForMobilePlatform();
                if (window.NativeLog) window.NativeLog.postMessage("[YT] fullscreen handler completed");
              } catch(e) {
                if (window.NativeLog) window.NativeLog.postMessage("Fullscreen error: " + e);
              }
              if (window.NativeLog) window.NativeLog.postMessage("[YT] sending Ready");
              sendMessage('Ready', event);
              if (window.NativeLog) window.NativeLog.postMessage("[YT] Ready sent");
            },
            onStateChange: function (event) {
              if (window.NativeLog) window.NativeLog.postMessage("[YT] StateChange=" + event.data);
              clearTimeout(timerId);
              sendMessage('StateChange', event.data);
              if (event.data == 1) {
                timerId = setInterval(function () {
                  var state = {
                    'currentTime': player.getCurrentTime(),
                    'loadedFraction': player.getVideoLoadedFraction()
                  };

                  sendMessage('VideoState', JSON.stringify(state));
                }, 100);
              }
            },
            onPlaybackQualityChange: function (event) {
              sendMessage('PlaybackQualityChange', event.data);
            },
            onPlaybackRateChange: function (event) {
              sendMessage('PlaybackRateChange', event.data);
            },
            onApiChange: function (event) {
              sendMessage('ApiChange', event.data);
            },
            onError: function (event) {
              if (window.NativeLog) window.NativeLog.postMessage("[YT] PlayerError=" + event.data);
              sendMessage('PlayerError', event.data);
            },
            onAutoplayBlocked: function (event) {
              if (window.NativeLog) window.NativeLog.postMessage("[YT] AutoplayBlocked");
              sendMessage('AutoplayBlocked', event.data);
            },
          },
        });
        player.setSize(window.innerWidth, window.innerHeight);
      }

      window.addEventListener('message', (event) => {
        try {
          var data = JSON.parse(event.data);

          if(data.function){
            var rawFunction = data.function.replaceAll('<<quote>>', '"');
            if (rawFunction.includes('loadVideoById')) {
              if (window.NativeLog) window.NativeLog.postMessage("[YT] loadVideoById=" + rawFunction);
            } else if (rawFunction.includes('playVideo')) {
              if (window.NativeLog) window.NativeLog.postMessage("[YT] playVideo");
            }
            var result = eval(rawFunction);

            if(data.key) {
              var message = {}
              message[data.key] = result
              var messageString = JSON.stringify(message);

              event.source.postMessage(messageString , '*');
            }
          }
        } catch (e) {
          if (window.NativeLog) window.NativeLog.postMessage("[YT] bridge error: " + e);
        }
      }, false);

      window.onresize = function () {
        player.setSize(window.innerWidth, window.innerHeight);
      };

      function sendPlatformMessage(message) {
        switch(platform) {
           case 'android':
           case 'ios':
           case 'macos':
             if (typeof id !== 'undefined') {
               id.postMessage(message);
             } else if (window.id) {
               window.id.postMessage(message);
             }
             break;
           case 'web':
             window.parent.postMessage(message, '*');
             break;
         }
      }

      function sendMessage(key, data) {
         var message = {};
         message[key] = data;
         message['playerId'] = 'id';
         var messageString = JSON.stringify(message);

         sendPlatformMessage(messageString);
      }

      function getVideoData() {
        return prepareDataForPlatform(player.getVideoData());
      }

      function getPlaylist() {
        return prepareDataForPlatform(player.getPlaylist());
      }

      function getAvailablePlaybackRates(){
        return prepareDataForPlatform(player.getAvailablePlaybackRates());
      }

      function prepareDataForPlatform(data) {
        if(platform == 'android') return data;

        return JSON.stringify(data);
      }

      function handleFullScreenForMobilePlatform() {
        // Disabled cross-origin DOM access to prevent SecurityError which aborts onReady.
        // Fullscreen should be handled via the API or allowed via allowfullscreen attribute.
      }

      if (window.NativeLog) {
          window.NativeLog.postMessage("player.html parsed and running!");
      }
    </script>
  </body>
</html>
