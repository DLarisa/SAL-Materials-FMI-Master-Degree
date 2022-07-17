#include "sha-256.h"
#include <stdio.h>

int main(int argc, char * argv[])
{
	FILE * f = NULL;
	unsigned int i = 0;
	unsigned int j = 0;
	char buf[4096];
	uint8_t sha256sum[32];
	if( ! ( f = fopen( argv[1], "rb" ) ) )
        {
            perror( "fopen" );
            return( 1 );
        }
	
	sha256_context ctx;
        sha256_starts( &ctx );

        while( ( i = fread( buf, 1, sizeof( buf ), f ) ) > 0 )
        {
            sha256_update( &ctx, buf, i );
        }

        sha256_finish( &ctx, sha256sum );

        for( j = 0; j < 32; j++ )
        {
            printf( "%02x", sha256sum[j] );
        }

        printf( "  %s\n", argv[1] );
}
