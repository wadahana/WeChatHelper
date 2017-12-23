//
//  WCPAntiDebugHelper.m
//  WeChatPlugin
//
//  Created by wadahana on 22/12/2017.
//  Copyright © 2017 . All rights reserved.
//

#import "WCPAntiDebugHelper.h"

#import "fishhook.h"
#import <dlfcn.h>
#import <sys/sysctl.h>

#define kLogEnabled (0)

// Sources:
// https://www.coredump.gr/articles/ios-anti-debugging-protections-part-1/
// https://www.coredump.gr/articles/ios-anti-debugging-protections-part-2/
// https://www.theiphonewiki.com/wiki/Bugging_Debuggers

// Bypassing PT_DENY_ATTACH technique

static void * (*original_dlsym)(void *, const char *);
static int (*original_sysctl)(int *, u_int, void *, size_t *, void *, size_t);
static int (*original_sysctlbyname)(const char *, void *, size_t *, void *, size_t);
typedef struct kinfo_proc ipa_kinfo_proc;


int hooked_ptrace(int _request, pid_t _pid, caddr_t _addr, int _data)
{
#if (kLogEnabled)
    fprintf(stderr, "hooked_ptrace -> \n");
#endif
    return 0;
}

void * hooked_dlsym(void * __handle, const char * __symbol)
{
    if (strcmp(__symbol, "ptrace") == 0) {
        return &hooked_ptrace;
    }
    
    return original_dlsym(__handle, __symbol);
}

// Bypassing sysctl debugger checking technique

int hooked_sysctl(int *name, u_int namelen, void *oldp, size_t *oldlenp, void *newp, size_t newlen)
{
#if (kLogEnabled)
    fprintf(stderr, "hooked_sysctl -> ");
#endif
    int retval = original_sysctl(name, namelen, oldp, oldlenp, newp, newlen);
    if (name != NULL) {
#if (kLogEnabled)
        for (int i = 0; i < namelen; i++) {
            fprintf(stderr, "name[%d]=%d; ", i, name[i]);
        }
#endif
        if (namelen >= 4 /* && name[0] == CTL_KERN */ && name[1] == KERN_PROC && name[2] == KERN_PROC_PID) {
            struct kinfo_proc *pinfo = (struct kinfo_proc *)oldp;
            if (pinfo != NULL && *oldlenp >= sizeof(struct kinfo_proc)) {
#if (kLogEnabled)
                fprintf(stderr, "sysctl -> pflag (%x) \n", pinfo->kp_proc.p_flag);
#endif
                pinfo->kp_proc.p_flag = pinfo->kp_proc.p_flag & (~P_TRACED);
            }
        }
    }
#if (kLogEnabled)
    fprintf(stderr, "\n");
    fflush(stderr);
#endif
    return retval;
}

int hooked_sysctlbyname(const char * name, void * oldp, size_t * oldlenp, void * newp, size_t newlen) {
#if (kLogEnabled)
    fprintf(stderr, "sysctlbyname-> name(%s)\n", name);
#endif
    return original_sysctlbyname(name, oldp, oldlenp, newp, newlen);
}

void * cfstockcreate_pointer = NULL;

@implementation WCPAntiDebugHelper

+ (void) load {
    
    original_dlsym = dlsym(RTLD_DEFAULT, "dlsym");
    original_sysctl = dlsym(RTLD_DEFAULT, "sysctl");
    original_sysctlbyname = dlsym(RTLD_DEFAULT, "sysctlbyname");
    struct rebinding rbs[] = {
        {"dlsym", hooked_dlsym},
        {"sysctl", hooked_sysctl},
        {"sysctlbyname", hooked_sysctlbyname},
    };
    
    rebind_symbols(rbs, 3);
}
@end
