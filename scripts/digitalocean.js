var dio = require( 'digio-api' )( process.env.DO_ACCESS_TOKEN );

module.exports = function( robot ) {

    var 
    dropletList = [],
    imagesList = [],
    errMsg = 'I seem to be having some issues fufilling this request';

    function isAble( user ) {
       return !!~user.roles.indexOf( 'digitalocean' ); 
    }

    function getNames ( droplet ) {
        return droplet.name; 
    }

    function getDropletByName ( name ) {

        function byName ( droplet ) {
            return droplet.name === name;
        }

        return dropletList.filter( byName )[0];
    }

    function getDroplets( callback ) {
        if ( !dropletList.length ) {
            return dio.droplets.list( function( err, res ) {
                if ( err ) return callback( err );
                dropletList = res.droplets;
                callback( null, dropletList );       
            } );
        }
        callback( null, dropletList );
    }

    function getImages( callback ) {
        if ( !imagesList.length ) {
            return dio.images.list( function( err, res ) {
                if ( err ) return callback( err );
                imagesList = res.images;
                callback( null, imagesList );
            } );
        }
        callback( null, imagesList );
    }

    robot.respond( /list droplets/i , function( msg ) {

        getDroplets( function( err, droplets ) {
            if ( err ) {
                return msg.send( errMsg );
            }

            var names = '- ' + droplets.map( getNames ).join( ' \n- ' );
            msg.send( names );
        } );

    } );

    robot.respond( /list images/i, function( msg ) {

        getImages( function( err, images ) {
            if ( err ) {
                return msg.send( errMsg );
            }
            var names = '- ' + images.map( getNames ).join( ' \n- ' );
            msg.send( names );
        } );

    } );

    robot.respond( /reboot droplet (.+)/i, function( msg ) {

        var name = msg.match[1],
            user = msg.message.user,
            droplet;

        if ( !isAble( user ) ) {
            return msg.send( 'sorry @' + user.name + ' you do not have access to do that' );
        }

        function rebootDroplet( id ) {
            dio.droplets.reboot( id, function( err, res ) {
                if ( err ) {
                    return msg.send( errMsg );
                }
                msg.send( name + ' droplet is rebooting.' );
            } );
        }

        getDroplets( function( err, droplets ) {
            if ( err ) {
                return msg.send( errMsg );
            }

            droplet = getDropletByName( name );

            if ( !droplet ) {
                return msg.send( 'No droplet "' + name + '" found.');
            }

            rebootDroplet( droplet.id );

        } );

    } );

    // TODO

    // robot.respond( /create droplet (.*) from image (.*)/i, function( msg ) {

    //     var name = msg.match[1],
    //         user = msg.message.user,
    //         droplet;

    //     if ( !isAble( user ) ) {
    //         return msg.send( 'sorry @' + user.name + ' you do not have access to do that' );
    //     }

    //     msg.send( JSON.stringify( msg.match, null, '\t' ) );
    // } );
};