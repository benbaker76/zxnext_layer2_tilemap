

// Program org
#pragma output CRT_ORG_CODE				= 0x8184

// Stack pointer with mod LUTs (0xC000-256)
#pragma output REGISTER_SP				= 0xBF00

#pragma output CRT_STACK_SIZE			= 128
#pragma output CRT_APPEND_MMAP			= 1
#pragma output CLIB_MALLOC_HEAP_SIZE	= 0
#pragma output CLIB_STDIO_HEAP_SIZE		= 0
#pragma output CLIB_FOPEN_MAX			= -1
#pragma output CRT_ORG_BANK_17			= 0x4000
#pragma output CRT_ORG_BANK_18			= 0x4000
#pragma output CRT_ORG_BANK_32			= 0xC000
#pragma output CRT_ORG_BANK_33			= 0xC000
#pragma output CRT_ORG_BANK_19			= 0xA000

