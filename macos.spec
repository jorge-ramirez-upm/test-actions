# -*- mode: python -*-
# Create RepTate distribution with
# pyinstaller RepTate.spec

block_cipher = None

a = Analysis(['testJR/__main__.py'],
             pathex=['testJR'],
             binaries=[],
             datas=[],
             hiddenimports=[
                 'packaging',
                 'packaging.version',
                 'packaging.specifiers',
                 'packaging.requirements',
                 'scipy._lib.messagestream',
                 'pandas._libs.tslibs.timedeltas',
                 'pkg_resources.py2_warn',
             ],
             hookspath=[],
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher)
pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)
exe = EXE(
    pyz,
    a.scripts,
    exclude_binaries=True,
    name='testJR_MacOS',
    debug=False,
    strip=False,
    upx=True,
    console=False,
)
coll = COLLECT(exe,
               a.binaries,
               a.zipfiles,
               a.datas,
               strip=False,
               upx=True,
               name='testJR_MacOS')
app = BUNDLE(
    coll,
    name='testJR_MacOS.app',
    version="0.8.5",
    #  version=get_versions(),
    licence="GPL v3+",
    author="Jorge Ramirez, Victor Boudara",
    bundle_identifier=None,
    info_plist={'NSHighResolutionCapable': 'True'})
