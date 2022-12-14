<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', '${var_db_name}' );

/** Database username */
define( 'DB_USER', '${var_db_user}' );

/** Database password */
define( 'DB_PASSWORD', '${var_db_pass}' );

/** Database hostname */
define( 'DB_HOST', '${var_db_host}:${var_db_port}' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

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
define( 'AUTH_KEY',         'put your unique phrase here' );
define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
define( 'NONCE_KEY',        'put your unique phrase here' );
define( 'AUTH_SALT',        'put your unique phrase here' );
define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
define( 'NONCE_SALT',       'put your unique phrase here' );

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
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
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */

//TODO
define( 'AS3CF_SETTINGS', serialize( array(
    // Storage Provider ('aws', 'do', 'gcp')
    'provider' => 'aws',
    // Access Key ID for Storage Provider (aws and do only, replace '*')
    //'access-key-id' => '************'
    // Secret Access Key for Storage Providers (aws and do only, replace '*')
    //'secret-access-key' => '****************',
    // GCP Key File Path (gcp only, absolute file path, not URL)
    // Make sure hidden from public website, i.e. outside site's document root.
    //'key-file-path' => '/path/to/key/file.json',
    // Use IAM Roles on Amazon Elastic Compute Cloud (EC2) or Google Compute Engine (GCE)
    'use-server-roles' => true,
    // Bucket to upload files to
    'bucket' => '${var_s3_bucket_name}',
    // Bucket region (e.g. 'us-west-1' - leave blank for default region)
    'region' => '${var_s3_bucket_region}',
    // Automatically copy files to bucket on upload
    'copy-to-s3' => true,
    // Enable object prefix, useful if you use your bucket for other files
    'enable-object-prefix' => true,
    // Object prefix to use if 'enable-object-prefix' is 'true'
    'object-prefix' => 'wp-content/uploads/',
    // Organize bucket files into YYYY/MM directories matching Media Library upload date
    'use-yearmonth-folders' => true,
    // Append a timestamped folder to path of files offloaded to bucket to avoid filename clashes and bust CDN cache if updated
    'object-versioning' => true,
    // Delivery Provider ('storage', 'aws', 'do', 'gcp', 'cloudflare', 'keycdn', 'stackpath', 'other')
    'delivery-provider' => 'storage',
    // Custom name to display when using 'other' Delivery Provider
    'delivery-provider-name' => 'Akamai',
    // Rewrite file URLs to bucket
    'serve-from-s3' => true,
    // Use a custom domain (CNAME), not supported when using 'storage' Delivery Provider
    'enable-delivery-domain' => false,
    // Custom domain (CNAME), not supported when using 'storage' Delivery Provider
    'delivery-domain' => 'cdn.example.com',
    // Enable signed URLs for Delivery Provider that uses separate key pair (currently only 'aws' supported, a.k.a. CloudFront)
    'enable-signed-urls' => false,
    // Access Key ID for signed URLs (aws only, replace '*')
    'signed-urls-key-id' => '********************',
    // Key File Path for signed URLs (aws only, absolute file path, not URL)
    // Make sure hidden from public website, i.e. outside site's document root.
    'signed-urls-key-file-path' => '/path/to/key/file.pem',
    // Private Prefix for signed URLs (aws only, relative directory, no wildcards)
    'signed-urls-object-prefix' => 'private/',
    // Serve files over HTTPS
    'force-https' => false,
    // Remove the local file version once offloaded to bucket
    'remove-local-file' => false,
    // DEPRECATED (use enable-delivery-domain): Bucket URL format to use ('path', 'cloudfront')
    //'domain' => 'path',
    // DEPRECATED (use delivery-domain): Custom domain if 'domain' set to 'cloudfront'
    //'cloudfront' => 'cdn.exmple.com',
) ) );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
