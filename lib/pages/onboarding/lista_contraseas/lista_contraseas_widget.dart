import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lista_contraseas_model.dart';
export 'lista_contraseas_model.dart';

class ListaContraseasWidget extends StatefulWidget {
  const ListaContraseasWidget({super.key});

  static String routeName = 'ListaContraseas';
  static String routePath = 'listaContraseas';

  @override
  State<ListaContraseasWidget> createState() => _ListaContraseasWidgetState();
}

class _ListaContraseasWidgetState extends State<ListaContraseasWidget> {
  late ListaContraseasModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListaContraseasModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF1F4F8),
        appBar: responsiveVisibility(
          context: context,
          tabletLandscape: false,
          desktop: false,
        )
            ? AppBar(
                backgroundColor: Color(0xFFF1F4F8),
                automaticallyImplyLeading: false,
                leading: FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 30.0,
                  borderWidth: 1.0,
                  buttonSize: 60.0,
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF14181B),
                    size: 30.0,
                  ),
                  onPressed: () async {
                    context.pushNamed(HomePageWidget.routeName);
                  },
                ),
                title: Text(
                  'Contraseñas',
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        font: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.normal,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                        ),
                        color: Color(0xFF14181B),
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.normal,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyLarge.fontStyle,
                      ),
                ),
                actions: [],
                centerTitle: false,
                elevation: 0.0,
              )
            : null,
        body: SafeArea(
          top: true,
          child: FutureBuilder<ApiCallResponse>(
            future: MostrarContraCall.call(
              usuarioId: 1,
            ),
            builder: (context, snapshot) {
              // Customize what your widget looks like when it's loading.
              if (!snapshot.hasData) {
                return Center(
                  child: SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                  ),
                );
              }
              final columnMostrarContraResponse = snapshot.data!;

              return Column(
                children: [
                  SwitchListTile(
                    title: Text('Mostrar descifradas'),
                    value: _model.showDecrypted,
                    onChanged: (val) => setState(() => _model.showDecrypted = val),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final contra = getJsonField(
                          columnMostrarContraResponse.jsonBody,
                          r'$'
                        ).toList();
                        return ListView.builder(
                          itemCount: contra.length,
                          itemBuilder: (context, contraIndex) {
                            final contraItem = contra[contraIndex];
                            final servicio = getJsonField(
                              contraItem,
                              r'$["servicio"]',
                            ).toString();
                            final cifrada = getJsonField(
                              contraItem,
                              r'$["clave_cifrada"]',
                            ).toString();
                            final descifrada = getJsonField(
                              contraItem,
                              r'$["clave_descifrada"]',
                            ).toString();
                            final texto = _model.showDecrypted ? descifrada : cifrada;
                            return ListTile(
                              title: Text(servicio),
                              subtitle: Text(texto),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
