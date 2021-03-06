<?php
/**
 * Controls access to a module's javascript files on the filesystem. This script
 * should ensure that only files relative to module's path specified are
 * accessible.
 * By calling new NDB_Client(), it also makes sure that the user is logged in to
 * Loris.
 *
 * It also does validation to make sure required config settings are specified.
 *
 * Used by "new" style modules.
 *
 * PHP Version 5
 *
 *  @category Loris
 *  @package  MRI
 *  @author   Dave MacFarlane <driusan@bic.mni.mcgill.ca>
 *  @license  Loris license
 *  @link     https://github.com/aces/Loris-Trunk
 */
session_cache_limiter('private');



// Load config file and ensure paths are correct
set_include_path(
    get_include_path() . ":" .
    __DIR__ . "/../project/libraries:" .
    __DIR__ . "/../php/libraries"
);

require_once __DIR__ . "/../vendor/autoload.php";
// Ensures the user is logged in, and parses the config file.
require_once "NDB_Client.class.inc";
$client = new NDB_Client();
$client->initialize("../project/config.xml");

// Checks that config settings are set
$config =& NDB_Config::singleton();
$paths  = $config->getSetting('paths');

// Basic config validation
$basePath = $paths['base'];
if (empty($basePath)) {
    error_log("ERROR: Config settings are missing");
    header("HTTP/1.1 500 Internal Server Error");
    exit(1);
}


// Now get the file and do file validation
$Module = $_GET['Module'];
$File   = $_GET['file'];

if (empty($Module) || empty($File)) {
    error_log("Missing required parameters for request");
    header("HTTP/1.1 400 Bad Request");
    exit(2);
}

if (is_dir($basePath . "project/modules/$Module")
    || is_dir($basePath . "modules/$Module")
) {
    $ModuleDir = is_dir($basePath . "project/modules/$Module")
        ? $basePath . "project/modules/$Module"
        : $basePath . "modules/$Module";
    set_include_path(
        get_include_path() . ':' .
        $ModuleDir . "/php"
    );
} else {
    error_log("ERROR: Module does not exist");
    header("HTTP/1.1 400 Bad Request");
    exit(5);
}
// Make sure that the user isn't trying to break out of the $path by
// using a relative filename.
// No need to check for '/' since all downloads are relative to $basePath
if (strpos("..", $File) !== false) {
    error_log("ERROR: Invalid filename");
    header("HTTP/1.1 400 Bad Request");
    exit(4);
}


$FullPath = "$ModuleDir/static/$File";

if (!file_exists($FullPath)) {
    error_log("ERROR: File $File does not exist");
    header("HTTP/1.1 404 Not Found");
    exit(5);
}

$MimeType = "text/css";

$mtime = new DateTime();
$mtime->setTimestamp(filemtime($FullPath));
header("Last-Modified: " . $mtime->format(DateTime::RFC822));

if (isset($_SERVER['HTTP_IF_MODIFIED_SINCE'])) {
    $ifmodifiedsince = new DateTime($_SERVER['HTTP_IF_MODIFIED_SINCE']);
    if (!($mtime > $ifmodifiedsince)) {
        header("HTTP/1.1 304 Not Modified");
        exit(0);
    }
}


$etag = md5(filemtime($FullPath));
header("ETag: $etag");
if (isset($_SERVER['HTTP_IF_NONE_MATCH'])
    && $_SERVER['HTTP_IF_NONE_MATCH'] === $etag
) {
    header("HTTP/1.1 304 Not Modified");
    exit(0);
}

// $MimeType = "application/javascript";
//header("Content-type: $MimeType");
$fp = fopen($FullPath, 'r');
fpassthru($fp);
fclose($fp);
?>
