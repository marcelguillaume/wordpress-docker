<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the website, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wordpress' );

/** Database password */
define( 'DB_PASSWORD', 'wordpress' );

/** Database hostname */
define( 'DB_HOST', 'db' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         'P&/$)GD!iuZI+FM~&9fIqw_a| H=AGJ)sW)~R;/u{gg,o@(K$0&LHarXR$5l2IG>' );
define( 'SECURE_AUTH_KEY',  'ZN<g8yRh{6t:*UtUVvD~]8RhdV#i8#gbHBZBG5{g~z{$jQBI4h+n.!jmKA]n:Zij' );
define( 'LOGGED_IN_KEY',    'm2%DEIH5t.7s{ip]IC9BZ&7iy;d#4!-HJ=}y,0_W/OCp:!2R1&ryw=|_&Mh3^2!0' );
define( 'NONCE_KEY',        'A!k963n]]XVt[^^ ACnh? P(v9z gzf#cq&~i aB3TuCspn*n219~1-q.?mhWHt|' );
define( 'AUTH_SALT',        '3M~pOA7r%ZOTSg?)[|EY;x!a?f{05,CBatj@x(;;4SOJlz8ANY<p50#8,K&F[^fd' );
define( 'SECURE_AUTH_SALT', 'UIcX[($I;xe;%g*34A,^D/V^j/{DVEY3~+ry^w5|W-A98JTf/D)k1!+r$?)_&f.}' );
define( 'LOGGED_IN_SALT',   'r6u#*,TE/ S29Zf%8vxhmDrxz 0O/`5Kr%}cQ,;z`E!62,6_3`O[kV_%51g!Yrkj' );
define( 'NONCE_SALT',       '%Ty]~K@1:mLh]TPETFiM=%:-.uMH:K6>2Z(u0WRN`.pkv,OvtOF|dT5|kE+,02<#' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 *
 * At the installation time, database tables are created with the specified prefix.
 * Changing this value after WordPress is installed will make your site think
 * it has not been installed.
 *
 * @link https://developer.wordpress.org/advanced-administration/wordpress/wp-config/#table-prefix
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://developer.wordpress.org/advanced-administration/debug/debug-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
