# users-media

Media player control aliases and utilities for playerctl.

## Overview

Provides convenient shell aliases and functions for controlling media playback
across multiple applications via playerctl. Includes playback controls, volume
management, and status/metadata queries.

Features:
* Playback control (play, pause, next, previous, stop)
* Volume adjustment and querying
* Track metadata and status display
* Per-application or last-played-media targeting

## Index

* [say-hello](#say-hello)
* [vol](#vol)

### say-hello

My super function.
Not thread-safe.

#### Example

```bash
echo "test: $(say-hello World)"
```

#### Options

* **-h** | **--help**

  Display help.

* **-v\<value\>** | **--value=\<value\>**

  Set a value.

#### Arguments

* **$1** (string): A value to print

#### Exit codes

* **0**: If successful.
* **1**: If an empty string passed.

#### Output on stdout

* Output 'Hello $1'.
  It hopes you say Hello back.

#### Output on stderr

* Output 'Oups !' on error.
  It did it again.

#### See also

* [validate()](#validate)
* [shdoc](https://github.com/reconquest/shdoc).

### vol

Query or set the current playback volume.
Without arguments, returns the current volume level (0.0-1.0).
With an argument, sets the volume to the specified level or adjustment.

#### Example

```bash
vol              # Show current volume
vol 0.5          # Set volume to 50%
vol 0.1+         # Increase by 10%
```

#### Arguments

* **$1** (string): Volume level (0.0-1.0) or adjustment (e.g., "0.05+", "0.1-")

#### Output on stdout

* Current volume level if no arguments provided.

#### See also

* [play-status](#play-status)
* [vol-up](#vol-up)
* [vol-down](#vol-down)