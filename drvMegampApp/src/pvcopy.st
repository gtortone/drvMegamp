program pvcopy

unsigned short copy_status, copy_result;
string copy_msg;

unsigned short copy_do;
unsigned short mod_src_num, mod_dest_num;
unsigned short ch_src_num;
uint16_t ch_dest_num, attr_num;
unsigned long pv_src, pv_dest;

assign copy_status to "{P}:COPY:STATUS";
assign copy_result to "{P}:COPY:RESULT:VAL";
assign copy_msg to "{P}:COPY:RESULT:MSG";

assign copy_do to "{P}:COPY:DO";

assign ch_src_num to "{P}:COPY:CH:SRC";
assign ch_dest_num to "{P}:COPY:CH:DEST";
assign mod_src_num to "{P}:COPY:MOD:SRC";
assign mod_dest_num to "{P}:COPY:MOD:DEST";
assign attr_num to "{P}:COPY:ATTR";

assign pv_src to "";
assign pv_dest to "";

monitor copy_do;

int i, k, try, fail;
int nattr, mask;
char pv_src_name[64];
char pv_dest_name[64];

%%#include <stdlib.h>

ss copy {
   state check {
      when (delay(0.5)) {

         pvGet(copy_do);
         if(copy_do) {

            copy_status = 1;	/* set running flag */
            pvPut(copy_status);

            pvGet(mod_src_num);
            pvGet(mod_dest_num);
            pvGet(ch_src_num);
            pvGet(ch_dest_num);
            pvGet(attr_num);

            fail = 0;
            nattr = atoi(macValueGet("NATTR"));

            for(i=0; (i<nattr && !fail); i++) {		// for each setting to copy...

               mask = (1 << i);
               if(attr_num & mask) {	 		// bit number i is set

                  for(k=0; (k<16 && !fail); k++) {			// for each destination channel...

                     mask = (1 << k);
                     if(ch_dest_num & mask) {		// bit number k is set

                        sprintf(pv_src_name, "%s:M%d:CH%d:ATTR%d:RAW", macValueGet("P"), mod_src_num, ch_src_num, i);
                        sprintf(pv_dest_name, "%s:M%d:CH%d:ATTR%d:RAW", macValueGet("P"), mod_dest_num, k, i);

                        pvAssign(pv_src, pv_src_name);
                        pvAssign(pv_dest, pv_dest_name);

                        try = 2;
                        while(!(pvConnectCount() == pvAssignCount()) && try) {
                           try--;
                        }

                        if(!try) {
                           pvAssign(pv_src, "");
                           sprintf(copy_msg,"%s",pv_src_name);
                           pvPut(copy_msg);
                           fail = 1;
                           continue;
                        }

                        try = 2;
                        while(!(pvConnectCount() == pvAssignCount()) && try--) {
                           try--;
                        }

                        if(!try) {
                           sprintf(copy_msg, "%s", pv_dest_name);
                           pvPut(copy_msg);
                           fail = 1;
                           continue;
                        }

                        copy_result = 0;
                        pvPut(copy_result);

                        sprintf(copy_msg, "%s", "Copy in progress ...");
                        pvPut(copy_msg);

                        pvGet(pv_src);
                        pv_dest = pv_src;
                        pvPut(pv_dest);

                        // printf("%s -> %s\n", pv_src_name, pv_dest_name);
                     }
                  }
               }
            }

            if(!fail) {

               sprintf(copy_msg, "%s", "Copy DONE"); 
               pvPut(copy_msg);           

            } else {

               copy_result = 1;
               pvPut(copy_result);
            }

            copy_status = 0;    /* set idle flag */
            pvPut(copy_status);

         }

      } state relax
   }

   state relax {
      when() {

         while(copy_do)
            pvGet(copy_do);

      } state check
   }
}
