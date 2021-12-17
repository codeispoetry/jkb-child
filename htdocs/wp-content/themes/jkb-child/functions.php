<?php

add_action( 'wp_enqueue_scripts', 'jkb_child_enqueue_styles' );
function jkb_child_enqueue_styles() {
    wp_enqueue_style( 'child-style', get_stylesheet_uri(), arraY('kr8-stylesheet'));
}

