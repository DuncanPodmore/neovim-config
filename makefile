ROSLYN_DIR := roslyn_server
ROSLYN_PLAT := linux-x64

# add roslyn server from https://dev.azure.com/azure-public/vside/_artifacts/feed/vs-impl/NuGet/Microsoft.CodeAnalysis.LanguageServer.<platform>/overview replace <platform> with one of the following linux-x64, osx-x64, win-x64, neutral 
setup:
	chmod +x $(ROSLYN_DIR)/content/LanguageServer/$(ROSLYN_PLAT)/Microsoft.CodeAnalysis.LanguageServer.dll

.PHONY: setup
