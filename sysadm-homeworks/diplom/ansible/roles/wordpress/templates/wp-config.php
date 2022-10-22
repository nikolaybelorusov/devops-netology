<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME', 'wordpress');

/** MySQL database username */
define('DB_USER', 'wordpress');

/** MySQL database password */
define('DB_PASSWORD', 'wordpress');

/** MySQL hostname */
define('DB_HOST', 'db01');

/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'p0?^{4N[-OTq, B(<ue|H7JZM}OA9vp%9*7svx-x58P]o+ >@mth,LXm+&~Oskty');
define('SECURE_AUTH_KEY',  'gMXW!|)7v2r`:RuLV?nm3?SdC=0enKvDbMokF}n/<Fhlz@-^A+%8xbTLazc& |nY');
define('LOGGED_IN_KEY',    ',-? ++0Jp2;se+.sIH69QwCuV}P%Yj-)/_t9z6KX[8xOEWk.~C<6^#(S`_-;y5([');
define('NONCE_KEY',        'Q>5!3bP5Mga)r7odSevd$7?FM}nR[BrCQ*N~mcj<d@N%Hx+#F9xFEm[|){|r 7*)');
define('AUTH_SALT',        '7V;+q8LTjc#.{Ed3x}.0_Loh*x)2^k?YmCd~j*;-$Z$:84PBgj[q#Y_OH9c^0!^8');
define('SECURE_AUTH_SALT', 'f@.jpzn}{nOCWI*t;Jwyjvdq<NAL1YU|<DT47r^?Apjff?+|c,&r3_I|]ZDJ8wJL');
define('LOGGED_IN_SALT',   'Ss%|UM/ ]A}fmkYx%l-2h(d/O gMkXh$3tPVrn)D]!q.AdViNSp]M`Ys cxkuwKT');
define('NONCE_SALT',       'jdJ:Wc->1{q(pJbrxy=R XMv)+v_fr|n$U-Sd]+bQ&c_G#eSnbdBs=wm}Z>|m*iJ');

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';
define('FS_METHOD', 'direct');
define('FORCE_SSL_ADMIN', true);
/**$_SERVER['REQUEST_URI'] = str_replace("/", "/wp-admin/",  $_SERVER['REQUEST_URI']);*/
if($_SERVER['HTTP_X_FORWARDED_PROTO'] == 'https'){

    $_SERVER['HTTPS'] = 'on';
    $_SERVER['SERVER_PORT'] = 443;
}


define('WP_HOME','https://www.eadipl.ru/');
define('WP_SITEURL','https://www.eadipl.ru/');

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */

define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
        define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
