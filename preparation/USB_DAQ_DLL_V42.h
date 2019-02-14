
#ifndef __USB_CARD_DLL__
#define __USB_CARD_DLL__

#ifndef USB_DAQ_DLL_V42_EXPORT
#define MYAPI __declspec(dllimport)
#else
#define MYAPI __declspec(dllexport)
#endif

 
#ifdef __cplusplus
extern "C" {
#endif

MYAPI int _stdcall OpenUsb_V42();
MYAPI int _stdcall  CloseUsb_V42();
MYAPI int _stdcall  GetDeviceCount_V42();
MYAPI int _stdcall  SetCurDevice_V42(int Devicenum);
MYAPI int _stdcall  Reset_Usb_Device_V42(void);
MYAPI int _stdcall  AD_single_V42(int mod_in,int gain,short* adResult);
MYAPI int _stdcall  AD_single_set_V42(int mod_in,int gain);
MYAPI int _stdcall  AD_single_read_V42(short* adResult);
MYAPI int _stdcall  AD_continu_V42(int mod_in,int chan,int Num_Sample,int Rate_Sample,short* databuf);
MYAPI int _stdcall  MAD_continu_V42(int mod_in,int chan_first,int chan_last,int Num_Sample,int Rate_Sample,short* mad_data);
MYAPI int _stdcall  AD_continu_config_V42(int mod_in,int chan,int Rate_Sample);  
MYAPI int _stdcall  MAD_continu_config_V42(int mod_in,int chan_first,int chan_last,int Rate_Sample);
MYAPI int _stdcall  Get_AdBuff_Size_V42(void);   
MYAPI int _stdcall  Read_AdBuff_V42(short* databuf,int num);
MYAPI int _stdcall  AD_continu_stop_V42(void);
 
#ifdef __cplusplus
}
#endif



#endif
