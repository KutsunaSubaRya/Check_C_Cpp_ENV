# Check_C_Cpp_ENV 專案

前言: 這是實習階段時寫給資訊老師與系統維護的老師的「gcc, g++ 安裝流程 (Windows) 書」與「驗證版本與向下兼容腳本」的文件。本測試以 APCS 為例子做測試，只要這個測試可通過，基本上其他比賽和考試參數與 flag 的部份都可以成功運行。

* 動機:
    * 在教育實習時協助學校辦校內學科能力競賽時，發現有學校電腦並未預先安裝 C/C++ 編譯器（如 gcc、g++），導致無法順利進行選手程式碼的編譯與測試。
    * 因此撰寫了一份針對 Windows 系統的 `MinGW-w64` 安裝與測試流程文件，並透過 MSYS2 安裝方式，搭配自動化腳本，協助老師與系統維護人員快速完成安裝與驗證。
* 目的:
    * 在 Windows 10 以上安裝 `MinGW-w64` (透過 [MSYS2](https://www.msys2.org/) 安裝)
    * 使用驗證版本與向下兼容腳本測試環境

* 參考安裝來源: msys2 官網 (https://www.msys2.org/)
* 未來修改
    * MSYS2 安裝 GCC / G++ 的流程當然可以部份也自動化，但有鑑於學校可以透過派發的方式進行，因此這項安裝自動化的流程我就先暫時不做，但有情況需求時再增加(如: 暫時部分電腦在還原卡備份無權限時需要臨時派發才會需要。)

---

## gcc, g++ 安裝流程 (Windows)

* 參考影片: 
    * https://drive.google.com/file/d/1HJdD0kSLVMwqxBB4Ws3RmZdyP45wGCFb/view?usp=sharing

1. 到 [msys2 官網](https://www.msys2.org/) 點擊 `msys2-x86_64-20250622.exe` 拿到 installer。
    * ![image](https://github.com/user-attachments/assets/306cd436-2d1d-4f08-b618-0b9b94be387b)
2. 按 Next 即可，可以根據學校內的需求放置至對應資料夾，屆時 環境變數 的路徑也會因此而變動
    * 我這裡使用預設的 `C:\msys64`
    * ![image](https://github.com/user-attachments/assets/74065f0c-5cc1-4906-afa3-cb329522cc87)
3. 繼續 Next 即可，安裝流程中看到 Show Details 可以打開透過 Logs 看到安裝狀況，在以下的流程會卡比較久，需要等待一下。
    ```
    ==> Disabling revoked keys in keyring...

      -> Disabled 4 keys.

    ==> Updating trust database...
    ```
4. 到這步驟時記得將 Run msys2 now 打勾 (預設是打勾的)，接著點 Finish
    * ![image](https://github.com/user-attachments/assets/49e2b824-0a59-4ecf-a556-37460cc5884d)
5. 接著會出現以下終端機頁面
    * ![image](https://github.com/user-attachments/assets/84324a8b-628a-419d-bff3-b73c6195eabf)
6. 將 `pacman -S mingw-w64-ucrt-x86_64-gcc` 貼上並按下 Enter 執行。
    * 下列是這個指令安裝的套件之解釋。

| 組件| 說明 |
| :-: | --- |
| `mingw-w64` | 使用 MinGW-w64 編譯器（支援 64 位元與新標準） |
| `ucrt`      | 使用 **UCRT（Universal C Runtime）** 作為底層 runtime，較 modern，與新版 Windows 相容性佳 |
| `x86_64`    | 64 位元版本 |
| `gcc`       | 提供的是 `gcc`, `g++` 等主編譯器工具 |

7. 接著會出現以下的詢問，直接 Enter 或是輸入 `Y` 再按 Enter 也可以。
```sh=
$ pacman -S mingw-w64-ucrt-x86_64-gcc
resolving dependencies...
looking for conflicting packages...

Packages (16) mingw-w64-ucrt-x86_64-binutils-2.44-4
              mingw-w64-ucrt-x86_64-crt-git-13.0.0.r21.gf5469ff36-1
              mingw-w64-ucrt-x86_64-gcc-libs-15.1.0-5  mingw-w64-ucrt-x86_64-gettext-runtime-0.25-1
              mingw-w64-ucrt-x86_64-gmp-6.3.0-2
              mingw-w64-ucrt-x86_64-headers-git-13.0.0.r21.gf5469ff36-1
              mingw-w64-ucrt-x86_64-isl-0.27-1  mingw-w64-ucrt-x86_64-libiconv-1.18-1
              mingw-w64-ucrt-x86_64-libwinpthread-13.0.0.r21.gf5469ff36-1
              mingw-w64-ucrt-x86_64-mpc-1.3.1-2  mingw-w64-ucrt-x86_64-mpfr-4.2.2-1
              mingw-w64-ucrt-x86_64-windows-default-manifest-6.4-4
              mingw-w64-ucrt-x86_64-winpthreads-13.0.0.r21.gf5469ff36-1
              mingw-w64-ucrt-x86_64-zlib-1.3.1-1  mingw-w64-ucrt-x86_64-zstd-1.5.7-1
              mingw-w64-ucrt-x86_64-gcc-15.1.0-5

Total Download Size:    69.02 MiB
Total Installed Size:  540.65 MiB

:: Proceed with installation? [Y/n]

```

8. 等待安裝完成後，直接關掉頁面即可，但是如影片所示，如果此時開啟 `終端機` 或 `Windows PowerShell` 輸入以下指令會發現沒有 gcc 和 g++ 指令，這代表尚未將此 binary 加入環境變數。
    * 我這裡用 `終端機` 作範例，學校內電腦理論上都有 `Windows PowerShell`，使用哪一個都可以。
    * ![image](https://github.com/user-attachments/assets/e6c32353-4393-4892-a060-76f9dab1ef1b)

9. 打開環境變數: `按下 Windows 鍵或是左下的放大鏡` > `輸入並點擊: 編輯系統環境變數` > `點擊右下角 環境變數` > `找到下欄 系統變數 中的 Path 欄位，雙擊它`
    * ![image](https://github.com/user-attachments/assets/68ba35d5-4eb6-44c3-9426-6b5a52dadb23)
    * ![image](https://github.com/user-attachments/assets/11b45597-fc14-438d-b00c-278918c0f914)
    * ![image](https://github.com/user-attachments/assets/ba73cdd8-188c-466b-90f9-c8beeabc16e8)

10. 找到剛才**流程第 2 點**我們選擇的路徑加上 `\ucrt64\bin` 後，點擊右上角的「新增」按鈕，並將路徑貼上，按下確定，確定，再確定。(因為剛剛開了環境變數三個頁面，都要按確定)。
    * 像我在第 2 點有提到我安裝在預設的 `C:\msys64`，因此我加上 `\ucrt64\bin` 後變成
        * `C:\msys64\ucrt64\bin`
    * ![image](https://github.com/user-attachments/assets/c17731c2-fc8b-4a1d-80be-61f3b256cab6)

11. 這點很重要，如果剛剛有開啟過 `終端機` 或 `Windows PowerShell`
    * 一定要重開 !! 一定要重開 !! 一定要重開 !!
12. 重開後輸入 `gcc --version` 和 `g++ --version`，理論上就會有顯示出版本了，這代表安裝成功，此時開啟 CodeBlocks 或是直接用 CLI 編譯並執行 `.c` 或 `.cpp` 檔案就可以用了。
    * ![image](https://github.com/user-attachments/assets/a306fb9f-ea33-4a55-b5d7-dfb1b7a37200)


## 驗證版本與向下兼容

由於我目前以上安裝後的編譯器是 c++ 17 和 C 語言 C23 版本的，都比目前任何比賽或考試的標準都高，雖然肯定有「向下兼容」，但也是需要確認安裝後機器上「是否可以運行特定的參數」，甚至是 `-lm` flag，因此我可以跟著我以下的方式測試版本與兼容性，我以下以 APCS 的參數作為測試。

![image](https://github.com/user-attachments/assets/b9fac703-aa11-4328-9c82-36ccf7efc230)

![image](https://github.com/user-attachments/assets/6816162a-fadb-473d-b3bb-355fce7a4e01)

1. 下載本專案會得到 `Check_env` 的資料夾，並進入資料夾
2. 看到 `check_env.ps1` 後，點擊它後右鍵點擊它，點選 `用 PowerShell 執行` 即可
    * ![image](https://github.com/user-attachments/assets/d50fd2ee-5f0e-441c-b69d-9a394f03a86d)
3. 如果出現以下畫面帶有兩行綠色的字，代表驗證成功，目前建置的環境是可以 `向下版本支援` 並符合考試的環境配置，當然這個能成功，其他比賽也可以符合。如果有例外情形，請查詢下列章節我所寫的「`check_env.ps1` Log History 對照表」
    * ![image](https://github.com/user-attachments/assets/272b0d7f-0f2c-486f-ae17-9a9103bc5931)

### `check_env.ps1` Log History 對照表

#### 成功與一般情形

| 階段       | 輸出內容                                                                 | 說明 |
|------------|--------------------------------------------------------------------------|------|
| [INFO]     | Checking gcc and g++ version...<br>gcc / g++ 版本資訊                    | 顯示目前系統安裝的 GCC 編譯器與 G++ 編譯器版本，確認為 MSYS2 GCC 15.1.0 |
| [STEP]     | Compiling c_version.c (C standard version)...                            | 使用 `gcc` 編譯 `c_version.c`，取得 C 預設標準版本（會輸出 `__STDC_VERSION__`） |
| [STEP]     | Compiling cpp_version.cpp (C++ standard version)...                      | 使用 `g++` 編譯 `cpp_version.cpp`，取得 C++ 預設標準版本（會輸出 `__cplusplus`） |
| [INFO]     | Detected C standard: `__STDC_VERSION__` = 202311                           | 編譯器預設支援的 C 語言標準版本是 C23（202311） |
| [INFO]     | Detected C++ standard: 201703                                            | 編譯器預設支援的 C++ 語言標準版本是 C++17（201703） |
| [STEP]     | Compiling C test (gnu99 + static + -lm)...                               | 用 `-std=gnu99` 編譯 `c_env_test_gnu99_static.c`，測試是否能向下相容舊 C 標準 |
| [STEP]     | Compiling C++ test (gnu++11 + static + -lm)...                           | 用 `-std=gnu++11` 編譯 `cpp_env_test_gnupp11_static.cpp`，測試是否能向下相容舊 C++ 標準 |
| [RUN]      | Running C test:<br>1.41                                                  | 執行舊 C 標準測試，輸出 `sqrt(2)` 結果為 `1.41` 表示運行正確 |
| [RUN]      | Running C++ test:<br>1.41                                                | 執行舊 C++ 標準測試，輸出 `sqrt(2.0)` 結果為 `1.41` 表示運行正確 |
| [VERIFY]   | Verifying backward compatibility (gnu99 / gnu++11)...                    | 驗證是否成功執行舊標準程式（即向下相容） |
| [PASS]     | Compiler successfully ran legacy-standard programs - backward compatibility verified. | 成功透過現代編譯器執行舊標準程式，代表支援向下相容 |
| [CLEANUP]  | Deleting generated executables...                                        | 自動清除所有 `.exe` 編譯結果檔 |
| [DONE]     | All executable files deleted.                                            | 清除完成，結束測試流程 |

#### 例外情形

| 標籤      | 錯誤訊息                                              | 說明 |
|-----------|-------------------------------------------------------|------|
| [ERROR]   | Failed to compile c_version.c                         | 使用 `gcc` 編譯 `c_version.c` 失敗，可能原因：檔案遺失、語法錯誤、編譯器未正確安裝 |
| [ERROR]   | Failed to compile cpp_version.cpp                     | 使用 `g++` 編譯 `cpp_version.cpp` 失敗，可能原因同上 |
| [ERROR]   | Failed to compile C test                               | 使用 `gcc -std=gnu99` 編譯 `c_env_test_gnu99_static.c` 失敗，表示現代編譯器不支援舊 C 標準或語法錯誤 |
| [ERROR]   | Failed to compile C++ test                             | 使用 `g++ -std=gnu++11` 編譯 `cpp_env_test_gnupp11_static.cpp` 失敗，表示現代編譯器不支援舊 C++ 標準或語法錯誤 |
| [FAIL]    | Legacy standard program failed to run as expected.     | 雖然成功編譯，但執行結果與預期不同（未輸出 1.41），可能代表執行環境或編譯方式不完全相容舊標準 |
