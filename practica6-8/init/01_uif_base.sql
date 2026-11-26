--
-- PostgreSQL database dump
--

\restrict P1MJ9yBFgGTk1l1HZbP8EcB27u5W8g0dS7xjrgMOMnVWeQkZmA3WssLAdbblTA3

-- Dumped from database version 16.15 (Debian 16.15-1.pgdg13+2)
-- Dumped by pg_dump version 18.6

-- Started on 2026-11-23 04:18:45

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 925 (class 1247 OID 41539)
-- Name: dominio_codigo_postal; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.dominio_codigo_postal AS character(5)
	CONSTRAINT dominio_codigo_postal_check CHECK ((VALUE ~ '^[0-9]{5}$'::text));


ALTER DOMAIN public.dominio_codigo_postal OWNER TO postgres;

--
-- TOC entry 933 (class 1247 OID 41561)
-- Name: dominio_curp; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.dominio_curp AS character varying(18)
	CONSTRAINT dominio_curp_check CHECK (((VALUE)::text ~ '^[A-Z]{4}[0-9]{6}[HM][A-Z]{5}[0-9A-Z][0-9]$'::text));


ALTER DOMAIN public.dominio_curp OWNER TO postgres;

--
-- TOC entry 941 (class 1247 OID 41627)
-- Name: dominio_numero_cuenta; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.dominio_numero_cuenta AS character varying(16)
	CONSTRAINT dominio_numero_cuenta_check CHECK (((VALUE)::text ~ '^[0-9]{16}$'::text));


ALTER DOMAIN public.dominio_numero_cuenta OWNER TO postgres;

--
-- TOC entry 929 (class 1247 OID 41542)
-- Name: dominio_rfc; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.dominio_rfc AS character varying(13)
	CONSTRAINT dominio_rfc_check CHECK (((VALUE)::text ~ '^[A-Z&Ñ]{3,4}[0-9]{6}[A-Z0-9]{3}$'::text));


ALTER DOMAIN public.dominio_rfc OWNER TO postgres;

--
-- TOC entry 937 (class 1247 OID 41593)
-- Name: dominio_telefono; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.dominio_telefono AS character varying(10)
	CONSTRAINT dominio_telefono_check CHECK (((VALUE)::text ~ '^[0-9]{10}$'::text));


ALTER DOMAIN public.dominio_telefono OWNER TO postgres;

--
-- TOC entry 917 (class 1247 OID 41052)
-- Name: monto_positivo; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.monto_positivo AS numeric(20,2)
	CONSTRAINT monto_positivo_check CHECK ((VALUE >= 0.00));


ALTER DOMAIN public.monto_positivo OWNER TO postgres;

--
-- TOC entry 921 (class 1247 OID 41064)
-- Name: numero_cuenta; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN public.numero_cuenta AS character varying(16)
	CONSTRAINT numero_cuenta_check CHECK (((VALUE)::text ~ '^[0-9]{16}$'::text));


ALTER DOMAIN public.numero_cuenta OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 229 (class 1259 OID 16906)
-- Name: alerta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alerta (
    id_alerta integer NOT NULL,
    id_transaccion integer NOT NULL,
    fecha_alerta timestamp without time zone NOT NULL,
    nivel_riesgo character varying(20) NOT NULL,
    CONSTRAINT fecha_valida CHECK ((fecha_alerta <= CURRENT_TIMESTAMP)),
    CONSTRAINT nivel_riesgo CHECK (((nivel_riesgo)::text = ANY ((ARRAY['Bajo'::character varying, 'Medio'::character varying, 'Alto'::character varying, 'Crítico'::character varying])::text[])))
);


ALTER TABLE public.alerta OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16838)
-- Name: bien; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bien (
    id_bien integer NOT NULL,
    tipo_bien character varying(50) NOT NULL,
    valor_comercial public.monto_positivo NOT NULL,
    CONSTRAINT clasificacion CHECK (((tipo_bien)::text = ANY ((ARRAY['Inmueble'::character varying, 'Vehículo'::character varying, 'Aeronave'::character varying, 'Embarcación'::character varying, 'Joya o metal precioso'::character varying, 'Obra de arte'::character varying, 'Blindaje'::character varying, 'Activo virtual'::character varying])::text[])))
);


ALTER TABLE public.bien OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16777)
-- Name: contribuyente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contribuyente (
    calle character varying(100) NOT NULL,
    actividad_economica character varying(100) NOT NULL,
    e_firma character varying(50) NOT NULL,
    rfc public.dominio_rfc NOT NULL,
    codigo_postal public.dominio_codigo_postal
);


ALTER TABLE public.contribuyente OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 49157)
-- Name: contribuyente_copia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contribuyente_copia (
    calle character varying(100),
    actividad_economica character varying(100),
    e_firma character varying(50),
    rfc public.dominio_rfc NOT NULL,
    codigo_postal public.dominio_codigo_postal
);


ALTER TABLE public.contribuyente_copia OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16828)
-- Name: cuenta_bancaria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cuenta_bancaria (
    numero_cuenta public.dominio_numero_cuenta NOT NULL,
    rfc public.dominio_rfc NOT NULL,
    fecha_apertura date NOT NULL,
    saldo numeric(20,2) NOT NULL,
    CONSTRAINT fecha_apertura_cuenta CHECK ((fecha_apertura <= CURRENT_DATE))
);


ALTER TABLE public.cuenta_bancaria OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 49162)
-- Name: cuenta_bancaria_copia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cuenta_bancaria_copia (
    numero_cuenta public.dominio_numero_cuenta NOT NULL,
    rfc public.dominio_rfc,
    fecha_apertura date,
    saldo numeric(20,2)
);


ALTER TABLE public.cuenta_bancaria_copia OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16878)
-- Name: desglose; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.desglose (
    id_reporte integer NOT NULL,
    numero_renglon integer NOT NULL,
    descripcion character varying(500) NOT NULL,
    monto public.monto_positivo NOT NULL,
    divisa character varying(10) DEFAULT 'MXN'::character varying,
    CONSTRAINT desglose_divisa CHECK (((divisa)::text = ANY ((ARRAY['MXN'::character varying, 'USD'::character varying, 'EUR'::character varying, 'CAD'::character varying, 'GBP'::character varying, 'CHF'::character varying])::text[]))),
    CONSTRAINT desglose_positivo CHECK (((monto)::numeric > 0.00))
);


ALTER TABLE public.desglose OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 57369)
-- Name: desglose_norm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.desglose_norm (
    id_reporte integer NOT NULL,
    renglon integer NOT NULL,
    descripcion character varying(200) NOT NULL,
    monto numeric(20,2) NOT NULL
);


ALTER TABLE public.desglose_norm OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 57354)
-- Name: entidad_norm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entidad_norm (
    id_notario integer NOT NULL,
    nombre_institucion character varying(50) NOT NULL,
    sector_economico character varying(50) NOT NULL
);


ALTER TABLE public.entidad_norm OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16843)
-- Name: entidad_reportante; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entidad_reportante (
    id_notario integer NOT NULL,
    nombre_institucion character varying(50) NOT NULL,
    sector_economico character varying(50) NOT NULL,
    CONSTRAINT sector CHECK (((sector_economico)::text = ANY ((ARRAY['Bancario y Financiero'::character varying, 'Notarial y Fe Pública'::character varying, 'Inmobiliario y Construcción'::character varying, 'Metales Preciosos y Joyería'::character varying, 'Juegos con Apuesta y Sorteos'::character varying, 'Vehículos y Blindaje'::character varying, 'Activos Virtuales y Fintech'::character varying])::text[])))
);


ALTER TABLE public.entidad_reportante OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16916)
-- Name: expediente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.expediente (
    num_expediente integer NOT NULL,
    id_alerta integer NOT NULL,
    fecha_apertura date NOT NULL,
    fiscal_asignado character varying(40) NOT NULL,
    CONSTRAINT fecha_valida CHECK ((fecha_apertura <= CURRENT_DATE)),
    CONSTRAINT fiscal CHECK ((TRIM(BOTH FROM fiscal_asignado) <> ''::text))
);


ALTER TABLE public.expediente OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16816)
-- Name: lista_bloqueados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lista_bloqueados (
    id_bloqueo integer NOT NULL,
    rfc public.dominio_rfc NOT NULL,
    fecha_bloqueo date NOT NULL,
    motivo character varying(50) NOT NULL,
    CONSTRAINT fecha_valida CHECK ((fecha_bloqueo <= CURRENT_DATE)),
    CONSTRAINT id_positivo CHECK ((id_bloqueo > 0))
);


ALTER TABLE public.lista_bloqueados OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16848)
-- Name: operacion_vulnerable; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.operacion_vulnerable (
    id_operacion integer NOT NULL,
    rfc public.dominio_rfc NOT NULL,
    id_bien integer NOT NULL,
    id_notario integer NOT NULL,
    valor_pactado public.monto_positivo NOT NULL,
    fecha_operacion date NOT NULL,
    CONSTRAINT operacion_fecha CHECK ((fecha_operacion <= CURRENT_DATE)),
    CONSTRAINT valor_positivo CHECK (((valor_pactado)::numeric > 0.00))
);


ALTER TABLE public.operacion_vulnerable OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16784)
-- Name: persona_fisica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persona_fisica (
    rfc public.dominio_rfc NOT NULL,
    curp public.dominio_curp NOT NULL,
    nombre character varying(50) NOT NULL,
    ingresos public.monto_positivo NOT NULL
);


ALTER TABLE public.persona_fisica OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16796)
-- Name: persona_moral; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persona_moral (
    rfc public.dominio_rfc NOT NULL,
    representante_legal character varying(50) NOT NULL,
    razon_social character varying(50) NOT NULL,
    fecha_constitucion date NOT NULL,
    CONSTRAINT fecha_constitucion CHECK ((fecha_constitucion <= CURRENT_DATE))
);


ALTER TABLE public.persona_moral OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 57359)
-- Name: reporte_norm; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reporte_norm (
    id_reporte integer NOT NULL,
    fecha_reporte timestamp without time zone NOT NULL,
    id_notario integer NOT NULL
);


ALTER TABLE public.reporte_norm OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16868)
-- Name: reporte_uif; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reporte_uif (
    id_notario integer NOT NULL,
    id_reporte integer NOT NULL,
    tipo_reporte character varying(50) NOT NULL,
    fecha_recepcion date NOT NULL,
    monto_total numeric(20,2) NOT NULL,
    CONSTRAINT monto_positivo CHECK ((monto_total > 0.00)),
    CONSTRAINT reporte_fecha_valida CHECK ((fecha_recepcion <= CURRENT_DATE)),
    CONSTRAINT reporte_tipo CHECK (((tipo_reporte)::text = ANY ((ARRAY['Operación Relevante'::character varying, 'Operación Inusual'::character varying, 'Operación Preocupante'::character varying, 'Aviso de Actividad Vulnerable'::character varying])::text[])))
);


ALTER TABLE public.reporte_uif OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16806)
-- Name: telefono; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.telefono (
    rfc public.dominio_rfc NOT NULL,
    numero public.dominio_telefono NOT NULL
);


ALTER TABLE public.telefono OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16891)
-- Name: transaccion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transaccion (
    id_transaccion integer NOT NULL,
    cuenta_origen public.dominio_numero_cuenta NOT NULL,
    cuenta_destino public.dominio_numero_cuenta NOT NULL,
    monto public.monto_positivo NOT NULL,
    fecha_hora timestamp without time zone NOT NULL,
    CONSTRAINT cuentas_distintas CHECK (((cuenta_origen)::text <> (cuenta_destino)::text)),
    CONSTRAINT fecha_valida CHECK ((fecha_hora <= CURRENT_TIMESTAMP)),
    CONSTRAINT monto_positivo CHECK (((monto)::numeric > 0.00))
);


ALTER TABLE public.transaccion OWNER TO postgres;

--
-- TOC entry 3600 (class 0 OID 16906)
-- Dependencies: 229
-- Data for Name: alerta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alerta (id_alerta, id_transaccion, fecha_alerta, nivel_riesgo) FROM stdin;
1	9	2025-11-23 04:36:19	Alto
2	151	2026-04-22 14:46:58	Crítico
3	76	2026-07-06 23:55:38	Alto
4	102	2026-08-04 09:23:14	Bajo
5	30	2025-11-25 15:06:56	Medio
6	83	2026-03-03 11:05:50	Crítico
7	48	2025-12-09 06:44:14	Alto
8	63	2026-09-30 14:19:02	Bajo
9	56	2026-05-31 17:25:33	Alto
10	96	2026-02-17 04:29:03	Medio
11	200	2026-09-28 12:47:00	Alto
12	32	2026-01-15 20:06:40	Bajo
13	82	2026-07-13 20:13:24	Bajo
14	184	2026-06-27 21:07:49	Alto
15	55	2026-08-14 19:45:58	Crítico
16	146	2025-11-07 21:37:02	Alto
17	60	2026-03-10 14:51:45	Bajo
18	99	2026-09-22 14:09:18	Alto
19	155	2026-07-20 09:36:34	Medio
20	135	2026-09-26 20:16:37	Medio
21	27	2026-10-16 19:41:58	Alto
22	184	2026-03-04 08:00:37	Bajo
23	147	2026-10-16 01:42:38	Crítico
24	175	2026-08-03 21:26:20	Crítico
25	82	2026-01-06 03:23:05	Alto
26	51	2026-10-19 04:10:00	Medio
27	13	2026-06-17 08:00:55	Crítico
28	128	2026-08-08 20:59:28	Bajo
29	71	2026-03-23 15:57:32	Crítico
30	31	2026-05-20 22:50:31	Bajo
31	116	2025-11-06 22:17:07	Medio
32	154	2026-07-17 11:44:44	Alto
33	152	2026-04-07 00:02:44	Crítico
34	61	2026-04-12 03:07:52	Bajo
35	73	2026-09-22 18:17:08	Bajo
36	165	2026-07-18 17:49:28	Bajo
37	119	2026-07-19 11:42:30	Alto
38	34	2025-11-25 07:16:01	Crítico
39	10	2025-11-26 15:37:25	Bajo
40	87	2026-01-15 08:31:50	Bajo
41	18	2026-09-17 20:12:02	Crítico
42	25	2026-08-24 01:57:57	Crítico
43	186	2026-05-15 04:45:30	Alto
44	71	2025-12-28 17:07:47	Alto
45	193	2026-08-11 12:34:21	Alto
46	103	2026-02-12 23:25:38	Bajo
47	143	2025-12-04 00:50:43	Alto
48	127	2026-01-07 10:48:40	Bajo
49	101	2026-04-22 14:58:38	Alto
50	179	2025-11-18 17:02:56	Crítico
51	127	2026-02-16 10:17:01	Bajo
52	96	2026-06-25 18:06:06	Bajo
53	8	2026-01-17 14:03:49	Medio
54	13	2026-07-26 21:30:18	Bajo
55	36	2026-05-16 17:28:59	Bajo
56	83	2026-04-09 08:42:03	Crítico
57	58	2026-01-07 14:22:51	Medio
58	23	2026-07-06 03:37:21	Medio
59	186	2026-08-18 11:08:44	Alto
60	138	2026-09-24 11:21:54	Bajo
61	177	2026-09-22 19:37:07	Bajo
62	67	2025-11-02 16:15:13	Bajo
63	29	2026-03-02 06:27:49	Bajo
64	78	2026-02-15 17:51:27	Bajo
65	68	2026-06-07 02:59:32	Alto
66	177	2026-03-17 14:49:09	Crítico
67	70	2025-12-17 03:22:46	Medio
68	36	2026-03-14 00:46:05	Crítico
69	31	2026-05-01 11:59:11	Medio
70	82	2026-06-10 01:57:32	Medio
71	193	2026-09-22 03:16:10	Crítico
72	164	2026-07-29 20:06:49	Crítico
73	172	2025-12-04 20:39:57	Bajo
74	134	2026-06-09 07:28:00	Medio
75	148	2026-10-28 16:58:18	Crítico
76	170	2026-04-30 05:43:23	Crítico
77	72	2025-12-05 15:55:45	Alto
78	198	2025-12-16 13:50:15	Crítico
79	58	2026-10-23 22:41:01	Bajo
80	68	2025-12-06 14:17:48	Alto
81	183	2026-01-11 07:13:57	Bajo
82	91	2026-08-11 18:06:09	Medio
83	169	2025-12-04 23:40:16	Medio
84	178	2026-01-12 12:39:59	Bajo
85	20	2026-03-04 17:31:36	Crítico
86	16	2026-06-19 00:06:14	Medio
87	4	2026-07-02 18:46:04	Medio
88	120	2025-11-09 05:36:52	Crítico
89	49	2026-08-26 04:34:21	Crítico
90	27	2026-01-06 04:31:28	Alto
91	54	2026-09-03 17:45:32	Alto
92	195	2025-11-05 11:29:45	Alto
93	182	2026-01-24 21:41:17	Crítico
94	168	2026-07-07 04:17:03	Medio
95	130	2026-03-26 21:04:07	Bajo
96	34	2026-04-29 04:57:53	Medio
97	94	2025-12-02 23:44:15	Crítico
98	116	2026-10-08 02:16:54	Medio
99	200	2026-08-09 16:56:56	Crítico
100	49	2026-02-05 05:54:37	Bajo
101	72	2026-02-28 22:56:21	Crítico
102	43	2026-09-22 14:28:46	Alto
103	148	2026-07-23 20:33:38	Bajo
104	38	2026-07-08 21:01:56	Crítico
105	28	2026-10-17 12:35:43	Bajo
106	62	2026-10-03 04:43:30	Bajo
107	118	2026-01-14 15:15:05	Medio
108	69	2026-08-18 16:33:06	Bajo
109	122	2026-08-21 23:04:12	Crítico
110	91	2026-08-15 01:53:18	Alto
111	31	2025-12-22 23:22:42	Bajo
112	91	2026-03-02 00:08:58	Crítico
113	55	2025-11-22 03:19:16	Medio
114	102	2026-03-28 17:37:47	Crítico
115	131	2026-08-02 13:47:43	Alto
116	14	2026-02-20 21:56:51	Crítico
117	70	2026-01-09 13:19:05	Alto
118	26	2026-02-17 18:19:39	Bajo
119	167	2025-12-25 23:03:58	Crítico
120	188	2026-06-08 20:45:15	Crítico
121	50	2026-03-03 23:15:19	Alto
122	49	2026-04-11 04:47:57	Crítico
123	46	2026-01-28 04:18:13	Alto
124	136	2026-09-21 19:31:48	Crítico
125	133	2026-01-13 12:46:24	Crítico
126	28	2026-02-15 08:52:30	Bajo
127	166	2026-10-10 13:39:22	Medio
128	29	2026-01-17 19:06:30	Medio
129	30	2026-01-09 05:00:16	Bajo
130	10	2026-02-23 23:10:08	Alto
131	62	2026-02-10 03:33:20	Bajo
132	137	2026-07-30 07:54:48	Bajo
133	71	2026-04-21 03:33:13	Medio
134	159	2026-02-12 03:56:23	Crítico
135	101	2025-12-07 07:32:35	Crítico
136	26	2026-05-10 16:15:56	Medio
137	188	2026-03-19 08:28:01	Alto
138	127	2026-06-14 04:02:22	Medio
139	44	2026-03-22 15:19:15	Medio
140	89	2026-03-16 21:48:13	Alto
141	181	2026-08-28 09:12:55	Alto
142	188	2026-07-08 16:27:04	Bajo
143	25	2026-05-23 13:18:42	Medio
144	129	2026-04-25 01:27:27	Crítico
145	190	2026-09-19 13:42:04	Alto
146	177	2026-07-04 11:47:33	Medio
147	44	2026-07-26 05:52:33	Alto
148	175	2026-09-20 10:29:23	Bajo
149	43	2026-01-06 15:08:20	Medio
150	86	2025-11-15 16:33:31	Crítico
151	37	2026-09-21 14:23:37	Bajo
152	171	2026-06-16 16:52:25	Crítico
153	110	2026-03-31 05:00:17	Alto
154	6	2025-12-31 21:28:07	Medio
155	68	2026-05-29 08:14:46	Bajo
156	44	2026-06-10 06:58:25	Bajo
157	153	2026-01-22 05:43:11	Alto
158	122	2026-08-01 03:03:42	Bajo
159	126	2026-04-18 22:00:25	Medio
160	121	2026-03-16 03:44:35	Bajo
161	12	2026-07-10 07:25:51	Bajo
162	146	2026-09-12 08:24:49	Alto
163	59	2026-07-24 07:03:59	Medio
164	194	2026-09-06 15:59:15	Medio
165	199	2026-02-21 12:58:36	Bajo
166	26	2026-01-20 23:44:45	Alto
167	189	2026-03-14 07:33:35	Alto
168	116	2026-07-31 03:26:47	Crítico
169	189	2026-05-16 01:37:57	Alto
170	140	2026-06-03 15:35:21	Alto
171	170	2026-09-19 17:02:04	Crítico
172	65	2026-08-17 00:41:25	Alto
173	118	2026-09-05 21:33:59	Bajo
174	91	2026-02-13 20:59:49	Alto
175	182	2025-12-06 16:07:17	Alto
176	133	2026-05-19 18:14:46	Crítico
177	29	2026-08-28 18:53:40	Alto
178	176	2026-01-22 06:16:17	Bajo
179	38	2026-02-09 16:55:40	Crítico
180	57	2026-01-25 04:29:00	Medio
181	92	2026-05-02 01:22:12	Crítico
182	8	2026-02-10 17:27:37	Medio
183	148	2025-11-13 15:19:02	Crítico
184	93	2026-10-25 11:06:42	Medio
185	191	2025-12-16 04:51:26	Bajo
186	50	2026-05-21 05:16:02	Crítico
187	164	2026-07-15 02:18:03	Bajo
188	71	2026-07-04 12:36:21	Crítico
189	135	2026-01-12 19:48:43	Medio
190	68	2026-05-04 23:28:36	Alto
191	85	2025-12-25 17:22:23	Crítico
192	151	2026-05-01 21:15:24	Crítico
193	71	2026-06-17 07:45:58	Alto
194	49	2026-03-06 20:41:39	Bajo
195	149	2026-03-26 00:07:37	Alto
196	157	2026-06-08 08:54:43	Bajo
197	111	2026-03-28 04:34:41	Crítico
198	146	2026-07-15 02:02:44	Alto
199	74	2026-06-17 22:23:59	Bajo
200	3	2026-10-17 10:41:28	Crítico
\.


--
-- TOC entry 3594 (class 0 OID 16838)
-- Dependencies: 223
-- Data for Name: bien; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bien (id_bien, tipo_bien, valor_comercial) FROM stdin;
1	Embarcación	1945914.44
2	Joya o metal precioso	2915221.63
3	Activo virtual	3851631.48
4	Blindaje	8570560.39
5	Embarcación	9952314.13
6	Joya o metal precioso	7280745.27
7	Embarcación	4212393.36
8	Blindaje	7935012.17
9	Inmueble	2937419.97
10	Joya o metal precioso	2393081.97
11	Activo virtual	9077915.94
12	Obra de arte	5849885.62
13	Activo virtual	903099.81
14	Activo virtual	1375389.11
15	Obra de arte	9745271.81
16	Blindaje	6884181.87
17	Blindaje	7099109.01
18	Joya o metal precioso	776903.40
19	Inmueble	568520.49
20	Embarcación	4735777.61
21	Obra de arte	9967557.40
22	Inmueble	103341.80
23	Blindaje	3059948.19
24	Blindaje	6729057.11
25	Aeronave	9682175.21
26	Inmueble	5825844.75
27	Joya o metal precioso	1740171.66
28	Activo virtual	9306753.06
29	Activo virtual	1362599.36
30	Obra de arte	7117042.97
31	Blindaje	1460867.55
32	Vehículo	3167032.60
33	Aeronave	5017145.64
34	Joya o metal precioso	7490842.51
35	Blindaje	2865108.81
36	Joya o metal precioso	6148669.13
37	Joya o metal precioso	5193878.22
38	Blindaje	8932084.51
39	Obra de arte	7381848.92
40	Activo virtual	7648570.37
41	Aeronave	5578963.35
42	Activo virtual	579560.77
43	Aeronave	592943.32
44	Aeronave	406829.37
45	Joya o metal precioso	1677371.82
46	Activo virtual	4392477.17
47	Activo virtual	455877.50
48	Obra de arte	9888744.91
49	Activo virtual	4604709.06
50	Vehículo	8466091.59
51	Aeronave	1280359.63
52	Vehículo	2077150.43
53	Joya o metal precioso	1847516.89
54	Aeronave	7511869.68
55	Joya o metal precioso	5654311.52
56	Embarcación	5856296.54
57	Inmueble	5283853.30
58	Aeronave	4193368.96
59	Vehículo	2499266.49
60	Activo virtual	6785239.74
61	Obra de arte	308323.58
62	Vehículo	3971989.54
63	Vehículo	8377923.23
64	Aeronave	337301.30
65	Activo virtual	8315457.29
66	Activo virtual	4567852.38
67	Joya o metal precioso	5962332.38
68	Inmueble	3327797.87
69	Inmueble	6578918.93
70	Activo virtual	3282908.91
71	Aeronave	2153100.27
72	Inmueble	8025501.73
73	Joya o metal precioso	3265549.92
74	Inmueble	7450809.92
75	Blindaje	970882.56
76	Joya o metal precioso	1821207.47
77	Blindaje	937423.66
78	Embarcación	1671259.80
79	Blindaje	2885112.10
80	Aeronave	1249989.74
81	Activo virtual	8020949.19
82	Joya o metal precioso	9042156.01
83	Aeronave	3622490.37
84	Vehículo	8328926.10
85	Embarcación	4921749.21
86	Blindaje	4790574.88
87	Blindaje	947712.38
88	Blindaje	8119393.88
89	Aeronave	4369353.93
90	Blindaje	974827.24
91	Obra de arte	9734054.32
92	Embarcación	6493725.64
93	Aeronave	9310142.75
94	Vehículo	2942495.09
95	Blindaje	837872.15
96	Activo virtual	3038912.88
97	Aeronave	6858923.68
98	Joya o metal precioso	8423302.65
99	Blindaje	2990042.26
100	Inmueble	5532393.58
101	Inmueble	5158474.45
102	Blindaje	4159543.07
103	Activo virtual	6625509.78
104	Joya o metal precioso	3586803.47
105	Vehículo	7698035.39
106	Inmueble	1183658.14
107	Activo virtual	1836544.35
108	Aeronave	8436952.74
109	Inmueble	878741.12
110	Joya o metal precioso	3173766.24
111	Activo virtual	7585674.93
112	Activo virtual	6256913.42
113	Joya o metal precioso	3446277.08
114	Aeronave	2150130.29
115	Vehículo	7482941.73
116	Joya o metal precioso	8722577.16
117	Vehículo	4366299.26
118	Inmueble	108178.34
119	Vehículo	182380.77
120	Activo virtual	4628622.02
121	Blindaje	8694366.18
122	Activo virtual	3062859.82
123	Obra de arte	6922089.81
124	Blindaje	8056175.31
125	Vehículo	1294640.42
126	Inmueble	1948480.73
127	Inmueble	6975522.80
128	Embarcación	8597169.70
129	Embarcación	4837116.08
130	Aeronave	6514911.27
131	Blindaje	8428792.61
132	Embarcación	906630.79
133	Activo virtual	1524248.19
134	Blindaje	267077.44
135	Aeronave	9029032.60
136	Activo virtual	9640475.36
137	Activo virtual	245296.40
138	Activo virtual	5873001.38
139	Embarcación	2983572.50
140	Blindaje	556675.69
141	Inmueble	1071502.04
142	Blindaje	9795895.03
143	Activo virtual	7383929.22
144	Joya o metal precioso	418321.29
145	Blindaje	4886704.56
146	Activo virtual	2357462.57
147	Inmueble	5306672.65
148	Blindaje	5785213.35
149	Vehículo	2715096.26
150	Blindaje	8896948.92
151	Vehículo	4973148.56
152	Obra de arte	4510837.66
153	Blindaje	257028.90
154	Joya o metal precioso	7275780.90
155	Activo virtual	3471281.53
156	Embarcación	5100977.66
157	Obra de arte	9221269.19
158	Activo virtual	1355027.74
159	Joya o metal precioso	7243800.28
160	Blindaje	9600043.51
161	Obra de arte	7969928.00
162	Aeronave	6237331.67
163	Joya o metal precioso	6922440.61
164	Vehículo	6687211.70
165	Aeronave	1774246.48
166	Aeronave	6077202.62
167	Vehículo	7945150.43
168	Activo virtual	3071336.34
169	Embarcación	5590463.58
170	Inmueble	3619928.20
171	Joya o metal precioso	3602586.55
172	Aeronave	1788412.21
173	Inmueble	8077814.65
174	Obra de arte	4334673.60
175	Embarcación	1250845.93
176	Embarcación	4889334.71
177	Obra de arte	7859613.75
178	Inmueble	7712444.18
179	Joya o metal precioso	8968361.11
180	Vehículo	7078728.93
181	Activo virtual	7999919.51
182	Vehículo	9747864.58
183	Vehículo	8244921.77
184	Inmueble	5097691.99
185	Aeronave	6317764.86
186	Embarcación	9114308.42
187	Aeronave	7297075.32
188	Activo virtual	7631548.67
189	Activo virtual	7338891.35
190	Vehículo	1585242.54
191	Obra de arte	3379344.88
192	Aeronave	1273685.52
193	Embarcación	4419129.19
194	Blindaje	7703732.03
195	Inmueble	2490894.84
196	Activo virtual	3446134.69
197	Aeronave	898076.92
198	Obra de arte	7166237.46
199	Blindaje	3638401.89
200	Embarcación	1558531.58
\.


--
-- TOC entry 3588 (class 0 OID 16777)
-- Dependencies: 217
-- Data for Name: contribuyente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contribuyente (calle, actividad_economica, e_firma, rfc, codigo_postal) FROM stdin;
Av. Insurgentes Sur 1602	Servicios de consultoria en informatica	EFIRMA990011223344556677889900AABBCCDDEEFF0011	GARM9004128A1	03920
Paseo de la Reforma 222	Comercio al por mayor de equipo de computo	EFIRMAAABBCCDDEEFF00112233445566778899001122	TLM8401017H2	06600
\.


--
-- TOC entry 3602 (class 0 OID 49157)
-- Dependencies: 231
-- Data for Name: contribuyente_copia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contribuyente_copia (calle, actividad_economica, e_firma, rfc, codigo_postal) FROM stdin;
Paseo de la Reforma 222	Comercio al por mayor de equipo de computo	EFIRMAAABBCCDDEEFF00112233445566778899001122	TLM8401017H2	06600
\.


--
-- TOC entry 3593 (class 0 OID 16828)
-- Dependencies: 222
-- Data for Name: cuenta_bancaria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cuenta_bancaria (numero_cuenta, rfc, fecha_apertura, saldo) FROM stdin;
3607252946789883	OYG110309OGX	2021-02-05	241226.62
5327830586440160	BDDE710412LZM	2023-04-20	3444005.53
8161682681664771	OYG110309OGX	2022-10-23	2942939.49
9737989689252528	EPRG760527E6I	2020-06-14	5597889.87
9458497750856794	MCBL930804LJD	2026-10-15	6841662.91
5418802171918600	RCI140116T8V	2025-07-07	6764611.91
3461930721037934	SED1607152J5	2021-08-14	4429941.53
2519726837930131	BCU100623QE4	2017-08-09	1817784.82
7004894604443727	RCI140116T8V	2019-07-31	4481342.45
4556143342533774	NDW2404175BG	2025-12-01	2355356.63
2794751456978560	ZPYX820429WZS	2026-05-30	7285429.64
1156542639052000	FXN980308W22	2018-01-08	4919806.99
8490149035992317	XEC120604HGZ	2021-12-12	284870.91
9742616360065707	IDH110323DTV	2018-05-11	7921190.98
9250874671579898	CLHA5609121WJ	2023-07-23	3452977.08
7093539219250800	MTTL5609207UW	2018-12-04	7675942.17
3703683041021228	GXX261001CNO	2019-03-17	4137176.32
2006305614900248	ZMMY631004S20	2026-04-19	1592234.12
7705500634532075	EZS04121472I	2021-08-02	7743316.14
1615527097233863	EPRG760527E6I	2024-03-07	7962359.71
9183304779050921	HVNM610505P0J	2020-06-02	4423570.74
6942850869373460	VWAT560531L72	2025-06-02	2812480.85
4219039915603203	FDYO470822R23	2022-03-31	4387350.61
9579316708782282	CXDL670401Y08	2022-08-30	5119912.58
9895349242796968	BAE160608RP2	2021-04-12	5940877.26
2615639639411028	GPF0408156T1	2024-07-14	4854761.78
7188366313795421	ABX001128PE6	2021-06-23	4283461.54
4207440345978338	VELK920216YIP	2021-01-06	4560412.10
3022300226733979	DYW070703T60	2022-04-21	2370887.16
1295369658985347	EDI110325IJI	2022-08-23	8737851.39
5606410340587623	PEH051113YE0	2020-05-31	6088551.81
8525616525686056	SED1607152J5	2024-08-27	8800057.61
7211839604663300	HDKY030704Y6W	2022-06-02	553285.04
7679088370052320	EDI110325IJI	2017-02-06	406543.51
3830787108902093	CVCU04052945B	2019-02-08	3140216.65
5407595300107752	VIB160319QGU	2016-11-12	5255910.82
8667798689116415	XEC120604HGZ	2024-12-09	8022140.34
7447455512899469	SYQU890425SEH	2016-11-26	3425470.11
2233527547708157	SFT0604233CD	2016-12-29	3106614.68
5486798008348449	QXVB910610FL0	2019-10-14	3707660.46
7678223610607232	JAWE650711H2M	2023-11-11	5951329.43
9838773636178697	OIDJ960901X15	2026-04-15	2111981.48
4985724512556360	FIWZ680927KXO	2025-02-24	5332988.74
4825397826212336	ISH220621J49	2023-07-07	589969.37
6656793048257106	LPCS9607124X1	2025-12-26	1030684.43
2294493794222726	QOFP4707153A3	2018-03-19	177898.06
7224431152318297	ECLL840110Q0Y	2018-02-24	336879.91
4465798586728229	KLT260226IQ2	2025-12-30	7770385.01
7288220242347356	OEJ120920EKR	2017-05-11	4633081.03
1158031497427759	YLR000217XDW	2024-05-28	2399936.66
4253857612488245	IWD23070611E	2018-12-06	4227564.26
6115334869827455	ISTW920603BCW	2022-11-02	8871890.15
8032839298716593	ZNYC5210158G8	2023-03-27	5133396.69
5450459302319412	LSXB0303112KN	2022-12-03	5153061.53
4759119075699849	DTG1909089G5	2023-05-31	900960.12
5731494318091287	CGF050914SA7	2019-11-05	1853571.89
2468436050437822	YIQ9809042LM	2016-12-22	4525165.32
6420463132740625	XEC120604HGZ	2018-12-15	6006654.30
9059231552006101	NXJS56032633I	2024-09-14	5533643.45
1691996267280637	HVZG561214TN7	2023-02-19	8724865.06
4172363123019974	QILP7302180DK	2020-02-12	4472816.93
2745730319204663	ZNHC710914GIG	2024-05-24	7563504.21
7040232345328795	NKD111129NGW	2016-12-28	1927113.90
2547198754440256	QRSR6704204W6	2020-08-07	428258.48
5681287193177625	CCT060715VN8	2017-03-02	3618545.16
3596516915658436	VCCT6309183UV	2021-08-12	5621338.32
7887706695651033	LKHG9407237P5	2022-12-02	6459502.73
8996635230804221	OCL150413MRU	2020-02-03	853055.17
7887968414238445	WOKD730105WB0	2018-05-13	2460647.70
8229000143163782	OEJ120920EKR	2021-12-27	7210770.45
5547817354302636	GBG070115DAN	2020-08-05	3844239.46
4884333020521633	IIZK890116S9X	2020-10-25	7160967.92
1169389549057533	YJY130510LA1	2025-03-26	7413738.68
8014877197360049	NDW2404175BG	2023-01-03	7237238.34
3769065173108798	REZ010808IGF	2017-06-16	5971278.55
9085975887089299	TYFA700611FEY	2021-08-10	1801092.83
5465911873087264	YYK10041998B	2025-03-20	2261757.50
9405092368447150	FHB150905856	2020-05-22	4079330.83
2316283173472659	QWT160405DNT	2016-12-14	4928288.62
3905783934171980	PCIZ870411ZS1	2020-03-02	5650781.51
5446967597850399	SJL220917JRH	2023-07-28	7764456.91
3034484965218178	PUR2007134XK	2018-09-20	4493083.08
8575866941300411	RCI140116T8V	2021-07-20	8659072.61
4309618815797571	HBF0302262VF	2026-07-07	8442957.89
7260337461383218	WLRQ721003VA2	2025-05-05	8434497.75
8602343777360470	BNH97071930L	2025-03-27	7280496.84
1438783977834992	MPM1312101H6	2019-09-25	8161569.03
1740821903430309	NXU080915YWE	2026-03-21	6539672.31
1059614525950970	SVKR89052139R	2020-02-17	4700665.14
9324742260160401	HVZG561214TN7	2026-06-16	4162648.93
4927754316283648	BBLM811204HVL	2026-06-12	1354678.65
7899266730035121	GPF0408156T1	2019-10-26	6889887.97
6221936982655407	BTK080502IH5	2017-12-11	3692637.23
6733630304384053	ZHQP56112508H	2019-01-05	5705530.43
9871750119198657	GVK2404226L1	2017-12-09	2402779.36
7557250290225738	TEDO6401208T6	2018-12-31	5814560.86
6394333181468890	QCLL86010685J	2021-04-01	6181850.70
9240434872035169	TJKO530612HTC	2026-07-12	3653090.52
2475292441078600	RZPU6202160YA	2020-09-16	1350085.25
4980622148760275	MUNC550723S8B	2025-09-24	2210656.70
6998014831282551	AUXR490822FPM	2021-07-01	4177705.23
2100590128581265	LPI04032800E	2020-02-05	8921642.31
1869227312067828	VBO990723P8I	2017-03-23	5822475.00
2890078206365293	SIEY960418MDD	2025-11-24	1818313.58
7244538328376944	QFXW861020CIY	2021-02-18	1228307.44
9495817443909294	GVOS890614SEK	2026-05-12	7107133.73
3323061345610514	WBAX9704075UU	2024-07-21	5928207.08
5275857731322057	WPUS640719T9N	2016-11-12	5798822.24
5196467046957649	HTLN941117L3Q	2024-02-05	8674100.12
8478788124818546	ZVY9903102KK	2017-09-18	7040212.59
3534784549443219	JAWE650711H2M	2022-04-30	7736326.23
4743480578496773	XHKD9409088KR	2024-03-10	2825486.02
5711856568500316	ZWAS511001YTJ	2023-10-03	7804612.43
9558090000075949	QHI020205SH3	2021-06-29	8071010.81
1038992020053813	YYO060712DKT	2018-11-26	5917046.71
1256187260466201	TWYK6510130TV	2025-08-25	3572357.01
7630869442961520	WYR0604221O4	2024-10-08	7584831.03
4671132863528505	TJKO530612HTC	2025-04-06	1007835.31
8411116574492332	ILB260220MAE	2022-12-25	4502486.63
4021165837964462	CZDZ600311409	2025-08-19	4697857.05
7178154238728514	VUK100713RWI	2017-07-28	8547095.67
4826300802266222	GKA15091421A	2020-08-26	2266646.62
4668471385517723	TWYK6510130TV	2017-08-18	2143072.66
3097503640835944	PZRA4604113KX	2021-07-24	6958831.36
6393169364662274	TYFA700611FEY	2023-12-24	2963908.56
5152715057209105	JNX980716G29	2025-11-21	6635258.56
8702397469739269	MRR990330J38	2024-06-20	6695758.79
1263540703108165	VBO990723P8I	2022-03-19	1962466.46
5707724124526482	WVCW980610IQV	2016-12-02	1576800.72
8204655962128844	SGKR641006KL1	2023-07-01	3955558.98
6342855622254409	BHQO620813L9T	2020-02-22	7766167.95
2182034351345457	JAWE650711H2M	2022-07-11	4413482.04
7325441221999343	OVPD740805EL6	2018-03-23	6296709.75
3744354007133134	DFPT880713XG1	2026-07-24	2848751.27
5225114202440119	VBO990723P8I	2017-04-06	4273949.69
5094988327296610	OIDJ960901X15	2020-09-02	8669856.40
2962452601802382	EQQV620323FYB	2024-01-16	3267300.61
7645495950711693	VZN251215RYO	2018-02-05	3309969.73
8620717349777150	DBCX500226MZS	2021-01-31	190157.36
6239074821528375	SCU010209AT7	2020-03-07	313767.48
2551103138219285	USC190403FZW	2019-08-19	5960179.80
5361783134534717	VTRN621210XPN	2022-06-07	6216296.76
9775341784813012	YYO060712DKT	2022-02-13	2157462.62
6753853480954258	IHL05022152W	2017-11-25	3462519.57
4570179131607920	JXE090922OKZ	2018-06-24	8626373.26
5631959940278586	TMNM671122LA8	2017-04-22	8128462.31
4276008057789597	GPF0408156T1	2024-12-30	1098922.89
7197376426551639	FVLH9710152IA	2024-03-07	7718895.43
8382177329118578	IVNS661005K3N	2017-03-29	71291.02
7562694668764235	LAP030128HVN	2022-07-09	8347602.85
4265316267719762	BHQO620813L9T	2021-02-02	2708342.92
6292654721313792	GMR0005103OD	2021-01-13	2119526.36
2575297000249137	AQDM871204BNH	2018-09-01	7734820.93
9290919888041559	UWXF681226ID2	2024-11-20	8243059.27
6385728302345922	PPM970223B7F	2020-11-20	2855000.63
8611037787003687	SED1607152J5	2022-08-18	5800043.29
7812171491183479	RYJT530127UTO	2017-10-04	2466691.71
9902558709989114	HKIP7110212XC	2022-07-04	7408868.42
9603287267815461	BAE160608RP2	2025-09-03	4240086.00
9038275786724196	GVK2404226L1	2020-11-10	8338511.73
7533366698248281	DUAO800519N2T	2018-01-27	6456615.47
8370420264766442	WVGU600626D54	2024-04-16	7419695.59
3731260790264202	JNR191022J9B	2018-06-17	2349100.19
6320364796726844	FCVJ7412271U3	2024-06-05	3167031.19
8496544091512283	PXZ010414HU7	2026-09-06	6563219.74
7053698385783542	LVI03042418O	2018-12-15	6640200.79
4384656520065231	VWZ190929EL8	2018-04-15	6257043.29
4253069530642795	QWT160405DNT	2017-11-12	469363.36
6347125113691756	SCN020310IRC	2017-05-26	1654064.73
6031918817346206	VMC150723B1K	2023-04-03	7119278.35
2115032704873526	IMGG451115DKN	2022-02-28	28180.70
4258440270832295	KTEK600420DRO	2017-12-09	5654852.31
7418053520124860	TYFA700611FEY	2019-01-01	5182496.20
4819881118987207	CXDL670401Y08	2017-11-20	1420823.04
5495584038141301	SJL220917JRH	2024-05-07	6422218.69
7504429714945520	MPM1312101H6	2017-10-06	7475677.12
1966693877642406	QWT160405DNT	2021-12-17	1171271.55
3498377931341988	TPB181211MC9	2024-03-06	6171937.53
1092525052752289	MXHU000813VMW	2017-12-13	4063683.35
9837046094658472	ILB260220MAE	2018-07-25	1202021.46
4136397632451833	IPDJ7709078ZO	2017-10-12	6187358.11
2252126257924898	OFST850214GV0	2026-05-07	7195858.25
2801661046809953	RRPV8406067DI	2017-09-20	760048.36
2068226289593803	AWOX050621HC3	2021-11-06	1637412.34
9894818877545874	ZNYC5210158G8	2023-04-28	8502842.02
2387321691756654	CMW070804XYF	2023-08-31	2020771.96
3591273567853235	ISTW920603BCW	2018-06-18	8308049.61
2667463454500130	COP000307TYT	2023-10-29	5508222.44
8227707722012740	PANG530604FPW	2020-10-18	8161649.60
3337702790055514	TZQ110927P9N	2017-01-04	1784796.69
6521020379366730	KQE070215H30	2024-07-18	7666551.93
7721155004785019	YXVG970921WTE	2023-05-13	3609613.68
4730728407555074	SFT0604233CD	2024-09-23	5403734.38
7664030708894487	JJFG5505017XV	2024-02-12	802006.88
9167668404995589	AWOX050621HC3	2018-07-22	1531520.89
8518688920737506	OEJ120920EKR	2022-08-11	1056595.99
9294794490987056	HZQ190528PNM	2017-04-10	4732776.38
3627073826096158	UIK161107FN1	2024-07-22	8279941.45
4854736821927577	VWZ190929EL8	2025-08-18	7445403.44
8126669414300840	ZDN230719AXP	2022-06-01	1067051.88
1234567890123456	GARM9004128A1	2023-01-15	150000.50
9876543210987654	TLM8401017H2	2023-05-20	50000.00
\.


--
-- TOC entry 3603 (class 0 OID 49162)
-- Dependencies: 232
-- Data for Name: cuenta_bancaria_copia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cuenta_bancaria_copia (numero_cuenta, rfc, fecha_apertura, saldo) FROM stdin;
9876543210987654	TLM8401017H2	2023-05-20	50000.00
\.


--
-- TOC entry 3598 (class 0 OID 16878)
-- Dependencies: 227
-- Data for Name: desglose; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.desglose (id_reporte, numero_renglon, descripcion, monto, divisa) FROM stdin;
1	1	Cómo región sueño comenzó tarde campaña.	13695.60	EUR
2	1	Asunto principales dicho sala.	6457.74	EUR
3	1	Proyectos hacen orden viene.	30017.82	USD
3	2	Alrededor niños decisión tú diario muchos.	37486.27	MXN
3	3	Dinero momento llevar cine puerto parís sabía.	29069.11	USD
4	1	Tomar administración arte resultados presenta situación película.	47749.36	GBP
4	2	Campaña del artículo fuentes viene.	37108.98	EUR
5	1	Sabe noviembre permite veces.	29912.93	USD
6	1	Sido animales fueron qué.	49012.63	EUR
6	2	Muestra naturaleza septiembre formas minutos ya san.	38792.76	CHF
7	1	Nivel especialmente grupo entrada riesgo proyectos américa.	26467.82	GBP
8	1	Fácil señora muestra hora.	11884.94	CAD
8	2	México algo eso valor cargo cabo.	1450.24	CAD
8	3	Respuesta rafael sigue.	16480.39	EUR
9	1	Producto mujer atención encuentro.	25491.80	CAD
10	1	Dicho primera voz quería pregunta quiero.	30471.81	USD
11	1	Aspectos al cuya menor habla valor.	33602.18	CHF
11	2	Democracia resultado mirada encima negro parece pudo.	2682.85	EUR
11	3	Mujer favor fueron voy.	16135.68	CHF
12	1	Ellos además agua estas cuales ocasión.	14399.17	CHF
13	1	Otra hecho dicho.	24435.85	USD
13	2	Personas perdido pudo relación años deseo lópez.	25256.25	CHF
13	3	Amigos imagen administración padres recursos.	48358.29	MXN
14	1	Teatro diez crecimiento pocos era todo.	8482.41	CHF
14	2	Cierto octubre constitución clase.	11320.04	CHF
15	1	Superior alguna metros libertad resto.	35319.96	MXN
16	1	Ningún fiscal ciento hace último.	42982.16	CHF
17	1	Concepto mejor cualquier pueda todavía lleva.	15655.99	CHF
17	2	Quería manuel haciendo diez tenía.	45706.44	USD
18	1	Trata plazo interior buscar.	27849.20	EUR
19	1	Después hecho hacer hacen él.	34217.04	EUR
19	2	Dios claro esos dolor.	38128.00	CAD
20	1	Nosotros país paciente horas marzo.	26864.38	EUR
21	1	Tienen fernando partir informe.	35122.44	USD
21	2	Sido empresa miguel da meses según hasta.	35354.32	GBP
22	1	Sistemas ex internacional construcción generales apenas.	5768.66	EUR
22	2	Contenido dio superior cinco radio viaje lucha otras.	37861.06	GBP
23	1	Campaña qué baja animales cambios relación color.	42640.68	CHF
24	1	José diversas tenían carácter muchas población pacientes.	23419.09	USD
24	2	Familia puso encuentran seis primero.	29280.71	CAD
25	1	Opinión otro estar sí.	24639.64	USD
25	2	Vez miedo palabra figura temas imposible espacio.	11278.55	CHF
25	3	Hermano pues organización políticas existen apenas hecho.	10587.10	CHF
26	1	Alta debía humanos.	18749.06	GBP
27	1	Precisamente deja unas modelo suficiente distintos.	34237.57	USD
28	1	Tiempos fue consejo veces precios serán fiscal.	47569.51	CAD
28	2	Vida fútbol ésta propios.	34292.82	USD
29	1	Necesidad partido septiembre orden permite principios.	5706.34	CAD
30	1	Junto educación nombre que.	47308.10	MXN
31	1	Apoyo usted familia corte sangre tales cuando puntos.	32854.79	GBP
31	2	Sueño vez y movimiento dicho caso puesto quedó.	22257.25	USD
31	3	Igual año siguiente otra ésta casi.	31721.65	CAD
32	1	Humana a carrera cuerpo.	2665.65	USD
33	1	Comisión dicho población frente local nada media.	24942.67	CHF
33	2	Estas libro principio ellas comercio dentro.	30211.62	USD
34	1	Verdad españa europa mercado sobre.	37514.81	CHF
34	2	Siguientes lenguaje noviembre les valor.	49567.03	CHF
34	3	Felipe quería voz doctor razones carácter carne.	33267.42	CAD
35	1	Millones constitución volver primera palabras con.	19722.95	CHF
35	2	Porque s estudio rey se.	33006.58	EUR
35	3	Junto capacidad pequeño final cómo diez cuerpo.	1568.52	MXN
36	1	Entrar afirmó final mejores.	6980.53	CHF
37	1	Soy mayo antes marcha mesa.	45515.44	USD
37	2	Flores principal económico proceso esto.	2128.31	GBP
37	3	Nosotros sistema algunos.	49380.12	CAD
38	1	Alta tanto mi.	34992.57	MXN
38	2	Crisis i conseguir países ir nos.	39922.84	USD
39	1	Encuentro podía siglo don ahí base.	24725.38	CHF
39	2	Cama frente de línea varios maría.	35434.11	EUR
40	1	Pequeña mundo cosas siguientes c.	7136.59	EUR
40	2	Estaba cargo hechos cierta momento.	4111.42	GBP
40	3	Construcción tengo cultural varias amor muestra.	10059.60	CHF
41	1	Experiencia durante forma pueda clase.	20296.03	GBP
42	1	Plan esfuerzo tomar.	24939.60	GBP
42	2	Será medida según pacientes objeto.	42020.05	GBP
42	3	Baja destino dice valores había.	35973.71	CHF
43	1	Base espera socialista peso u.	37921.90	USD
44	1	Hicieron cama consejo región debía donde capital.	44982.51	USD
44	2	Enero aquí nosotros arriba junto club así.	43238.17	CHF
44	3	Carta hijo políticas comercio r.	9816.94	GBP
45	1	Alto militar cuales ex.	40225.14	MXN
45	2	Mañana tras medio usted ve hacerlo mantener ninguna.	2918.01	GBP
46	1	Cinco industria segundo siglo les posible banco.	32979.38	MXN
47	1	Son entonces juicio trabajar meses.	13581.26	MXN
47	2	Dónde relación distintos.	5145.91	MXN
47	3	Ante haciendo lleva aquellas voz sistemas electoral.	25801.27	EUR
48	1	Quedó quién mesa voz vez.	9408.56	CHF
48	2	Suerte hizo peor.	1004.19	EUR
48	3	Mis una lucha dolor.	3262.15	GBP
49	1	Forma humanos ningún tomar comercio económico causa vuelta.	33298.72	CAD
49	2	Sé cualquier origen puso antonio.	7852.90	CAD
50	1	Sentido artículo solo rodríguez sí frente cosas.	16333.87	EUR
50	2	Social investigación metros reunión.	30702.43	GBP
50	3	Propio considera vuelta.	11282.14	MXN
51	1	He mejor ir ninguna siquiera dio éxito hoy.	41168.40	USD
51	2	Productos calle lo.	2799.96	USD
51	3	Serán encuentro había.	15685.75	USD
52	1	Cierta mujeres diversos cantidad volver.	30505.07	USD
53	1	Constitución forma estructura.	18594.19	USD
53	2	Industria otra madrid peso área sala.	36726.12	CAD
53	3	Mayoría toda yo autoridades formas.	4643.62	EUR
54	1	Como era defensa antes.	19707.33	USD
54	2	Trabajo esfuerzo o actual entonces bastante.	20602.91	MXN
55	1	Distintas tiempos puedo ocho abril.	34149.76	CHF
55	2	Embargo general año club persona alta les.	8018.95	USD
56	1	Cama españoles nueva popular.	31848.84	EUR
57	1	Frente medios aparece puedo hubo unidos militares meses.	35143.34	USD
57	2	Pocos hermano supuesto espera otro que corte.	36007.80	GBP
57	3	Diferencia algunos entonces deben.	33208.58	GBP
58	1	Cuba estos población artículo nuevo real mientras.	9038.11	USD
58	2	M central cerca aquellas clase ayuda.	16501.66	CAD
58	3	Chile tomar padre capital.	19568.15	GBP
59	1	Resultado figura menor proceso hace ocho tenemos.	4798.71	MXN
60	1	Enfermedad tu que niveles para.	6389.52	GBP
60	2	Soy españa general ii creo parís diferencia.	20932.28	EUR
60	3	Tierra mejor adelante r.	32368.70	EUR
61	1	Sociedad llamado yo hoy imposible especie.	39125.48	USD
61	2	Conocimiento diario medios han sino comunicación.	43573.91	USD
62	1	Democracia comercio sin española te otro apoyo.	1483.30	CAD
62	2	Días josé miedo actitud derecha cierto.	48994.78	USD
63	1	Quedó sector siquiera con estaba todos.	47637.36	MXN
63	2	Españoles cuenta va.	9610.84	CHF
64	1	Octubre análisis junio palabra título has.	29852.53	CAD
64	2	Largo guerra reforma mañana ella calle marzo.	5681.49	EUR
65	1	Estoy yo presencia unidad larga.	29035.75	EUR
65	2	Consumo cámara difícil primero dónde llamado nunca precio.	28025.57	GBP
65	3	Muchos nada después productos u me.	5854.24	MXN
66	1	Sea forma bajo las armas.	16581.82	CAD
67	1	Seguir silencio este siglo larga.	17913.47	CHF
68	1	Era diversas atención desde sí llegar conseguir.	48432.01	GBP
68	2	Curso calidad hemos niños político.	28031.91	CAD
68	3	Precisamente país seis construcción.	24366.23	USD
69	1	Carácter características o europea.	1465.38	GBP
69	2	Plan industria junto política puntos considera sí.	35947.91	CHF
70	1	Electoral cuestión tomar carrera va.	7990.84	GBP
71	1	Justicia fernando viejo precios aquella memoria español.	14101.13	CHF
71	2	Natural concepto son viaje hechos eran.	32320.48	EUR
71	3	Importantes curso sol afirmó país no vino propio.	35667.62	USD
72	1	Nuevas ninguna embargo equipo.	30826.45	CHF
72	2	Problema dios día fueron.	23431.54	CAD
72	3	Problemas pronto mis junio muestra nacional ayer.	49326.07	CAD
73	1	Necesario c unidos fondo quizá análisis primeros.	15054.16	CAD
73	2	Exterior propios puerta acto control ojos militares.	26509.14	CHF
73	3	Quizá encuentro construcción.	44188.00	USD
74	1	I importancia toda sino zona.	32146.13	MXN
74	2	Última ahora obras llegó sí uso dónde.	47425.28	CAD
75	1	Hacer mujer nada lenguaje servicio haya hablar.	42417.03	CHF
75	2	Trata n capacidad precisamente.	4894.27	CHF
76	1	Presidente ninguna defensa siguientes decir nuestra jóvenes.	47298.48	USD
77	1	Juez ni pasó diciembre imágenes nuestra bajo más.	3813.16	CHF
77	2	Todavía ayuda hace tiempo producción dicho.	15006.69	CAD
77	3	Operación crisis cargo carlos s tres abril.	40609.00	MXN
78	1	Pablo segundo dentro pacientes resultados presente.	34174.62	CHF
78	2	Peor anterior esfuerzo habría.	7684.99	CAD
79	1	Importancia aparece dentro.	34570.97	CHF
79	2	Alta sé diversas visita miedo estructura trata debe.	44515.95	CHF
79	3	Corte nuevas trata volver pie ojos quedó.	7109.89	MXN
80	1	Tipos asociación económico buenos común todo entrada.	10319.02	CHF
80	2	Ambos alguien poder calle segunda.	1357.22	CAD
80	3	R administración no aspectos su.	35426.99	CHF
81	1	Carácter santiago ambiente suelo existe.	12967.09	CHF
81	2	Propia técnica ir animales éste jorge.	33397.53	GBP
82	1	Población misma unión ministerio ningún solución crecimiento.	30850.49	GBP
82	2	Económico precisamente pone victoria menos durante.	22983.95	USD
82	3	Día su hermano estado.	34051.59	GBP
83	1	Trabajar menos sector salir este junto europa horas.	9565.90	EUR
84	1	Seguir presidente asunto suficiente ahí cuadro actividad.	26170.54	MXN
85	1	Los pesar posible derecho hacerlo nombre.	25279.89	USD
85	2	Plaza en armas este le mantener.	19290.90	MXN
86	1	Mejores cantidad iba lenguaje flores número teoría.	45788.21	USD
86	2	Alta tema porque hermano empresas.	41754.59	MXN
87	1	Perdido cuenta lópez mundial anterior menos.	15659.72	EUR
87	2	Estamos blanco programas ocasiones.	13972.79	MXN
88	1	Profesional democracia primer real sí sus un cierta.	31927.65	CAD
88	2	Ha cambios toma te.	11655.70	EUR
88	3	Sus corazón j económico fácil ciudad.	46526.34	CHF
89	1	Segundo presente padre libros llegado.	41460.64	MXN
89	2	Amigos hora etapa formas silencio.	46835.30	GBP
89	3	Santiago general trabajar ellos trabajo información mujer después.	42569.24	MXN
90	1	Esfuerzo parece mundo produce idea efecto.	1288.66	CAD
90	2	Otro puedo pesar seguridad pequeña pasó fueron las.	17099.04	EUR
91	1	Línea blanco salida unos.	1252.57	CHF
92	1	Niveles atención cuyo alguien primer construcción.	20701.34	MXN
93	1	Será si o fuerzas.	22109.39	USD
94	1	Habían española pp si.	26925.73	USD
95	1	Hizo fernando visita mujeres.	7068.29	CAD
95	2	Nuestro ella río encima niño costa cultura.	1338.61	CHF
96	1	Material cuerpo cuatro u región rosa.	12078.67	CAD
96	2	Experiencia vino cosa producto.	19341.16	EUR
97	1	Principio medida especialmente mañana tuvo caso vista.	44717.48	GBP
97	2	Sol puerta lleva tiene ver.	40765.65	MXN
98	1	Curso través dirección.	33157.70	CAD
98	2	Mira siquiera peor propia si fueron real enero.	8929.88	EUR
99	1	Padre ejemplo amor nuevo hemos del.	22264.05	EUR
99	2	Región nuestra sol.	44295.24	CHF
99	3	Pp cuales hubiera clase tenemos antes.	10724.77	USD
100	1	Vivir sistemas cuestión américa partidos.	2972.56	CAD
100	2	Acto siendo aspectos cuatro está central.	21631.73	EUR
101	1	Torno europa ayer.	8855.31	USD
102	1	Elecciones principal allí como.	48025.24	EUR
102	2	Encuentro asunto rafael.	6820.82	CAD
103	1	Verdad consumo dio cama grado son siquiera.	25282.81	CHF
103	2	Futuro s especial casos.	36001.73	EUR
103	3	Negro ciento cuya primero p tema.	37803.41	CAD
104	1	Figura república debía ocasiones pone antes posible.	36573.73	CHF
104	2	Lugar niveles podrá.	42310.08	CAD
104	3	Importante durante éxito habla cámara pasar.	7439.47	MXN
105	1	Comenzó dolor carlos.	7180.06	EUR
106	1	General encuentran e.	1668.80	CHF
106	2	Crecimiento enero tampoco derecha llama b.	12588.74	CHF
106	3	Mucho pregunta negro mucha.	41661.95	CAD
107	1	Oficial existencia duda san estaban aire.	37134.15	CAD
107	2	Varios régimen ley muerte equipo.	24529.46	EUR
107	3	M g sociedad reunión.	24810.53	CAD
108	1	Padres vida comunidad grandes grande.	31263.04	CHF
109	1	Vía he contra haber función decisión puso.	10156.15	EUR
109	2	Río bastante hija sino quien.	38569.65	EUR
109	3	Hubiera julio quizá ello ciento bien.	49718.60	USD
110	1	Nunca partir zonas haciendo entonces junio.	41209.86	USD
110	2	San vio ciudad me.	24220.75	MXN
110	3	Grupos algunas trabajar hace servicios debe carácter.	35356.10	GBP
111	1	Claro primeros único está vista propuesta historia.	9878.22	GBP
111	2	Dio podemos popular central principio.	31816.49	USD
111	3	Autor lenguaje hizo.	12239.83	USD
112	1	Cama libre eran.	2879.96	USD
112	2	Mundo importante quizá vivir presencia año corazón.	46525.82	CAD
113	1	Comunidad partido cualquier oficial santa.	31206.90	MXN
114	1	Corazón dijo jefe i nuestros.	19637.28	GBP
115	1	Industria crecimiento partido argentina aquí.	35307.78	USD
115	2	Revolución trabajo por hacía claro nueva.	11866.99	CAD
116	1	Razones partido humano del propia.	4006.14	CAD
116	2	B necesario final hacer mirada sol torno.	32549.78	EUR
117	1	Crisis ver algunos sí familia.	14193.06	EUR
118	1	Grupos campaña destino problemas efecto c.	35867.69	USD
118	2	Llamado casos claro.	16672.20	MXN
119	1	Juez asociación rodríguez especialmente poco radio fernando.	3003.57	MXN
120	1	Entonces dirección nadie.	37492.98	USD
120	2	Persona sin común diario.	14980.53	EUR
120	3	Total mayores historia dan buenos peor.	45515.62	MXN
121	1	Permite revolución consejo curso tenemos algunas permite voluntad.	10057.16	CAD
121	2	Izquierda deseo muchas tener dejar precisamente.	18815.48	EUR
122	1	Ellos produce sol volver esas general se trabajar.	5747.47	MXN
123	1	Uso debe piel elementos.	28036.64	USD
123	2	Podía podría atrás una.	17229.37	CHF
123	3	Usted tales ayer.	40691.73	CHF
124	1	Largo estudio línea de incluso puesto tú.	26914.24	EUR
124	2	Partes carrera toda gobierno meses explicó tipo.	12674.36	EUR
124	3	Grado cabeza este corte relación viene hubiera última.	11291.63	CAD
125	1	Aparece toma rey cuenta.	44472.50	USD
126	1	Permite real común hechos nuestro están.	37386.78	MXN
126	2	Nuestro familia director trabajar visto tras mayo.	3010.91	CHF
126	3	Sido tenemos acciones estamos políticas últimos.	41053.05	USD
127	1	Población europa dirección ha estudios constitución.	22842.72	MXN
127	2	Siempre nacional violencia llegado cine policía.	4669.10	GBP
127	3	Ministerio fuerte cuanto mitad tema dio y cuestión.	31331.51	EUR
128	1	Movimiento han han s muestra claro país.	24235.73	USD
128	2	García compañía entrar casa demasiado.	27144.32	USD
128	3	Modelo qué noche nuevo carta comunidad posible.	3146.74	USD
129	1	Casos ministro destino a.	27974.29	EUR
129	2	Elementos punto donde cómo aspecto económica gente.	44687.75	GBP
130	1	Soy octubre sector yo.	44850.74	CAD
130	2	Cierto atención tras tu.	31863.37	MXN
131	1	Hombres decía media pudo ayer algunos como.	4317.72	CAD
131	2	Vía lucha partido construcción.	26664.38	GBP
132	1	Punto sigue junto menos izquierda méxico hora.	9179.82	EUR
133	1	Ve caso dado medios ha cara.	48406.86	EUR
133	2	Ex cine entre muestra lucha imagen pequeña.	3226.82	GBP
133	3	Imposible difícil participación pueblo máximo últimos.	3978.88	CHF
134	1	Fuera rodríguez crisis congreso pueden política siete.	37295.04	CAD
135	1	Español ocho llegado dar fecha nivel dinero.	34550.02	GBP
135	2	Sabe mes amigos fuentes trabajar características crisis.	48605.38	USD
136	1	Derecha izquierda salir experiencia.	37785.66	CAD
136	2	Donde si conocimiento sentido partes nuevas.	28562.43	CAD
137	1	Sé sentido sola asimismo produce sino aspecto.	30753.70	USD
137	2	Estuvo ambos tiene p presidente u.	10019.25	USD
138	1	Arte puerta blanco si.	11672.58	CHF
138	2	Semana ambiente calle vuelve.	1434.20	GBP
138	3	Cuya juan investigación permite ley médico principio.	23316.61	CHF
139	1	Pasó será comunicación pueda existencia cualquier supuesto.	26728.59	EUR
139	2	Total quién queda.	42771.28	EUR
139	3	Quiere acto constitución fernando.	35704.48	GBP
140	1	Necesidad octubre habría soy propia secretario estudios.	9384.35	MXN
141	1	Creación media hubo temas.	12672.62	MXN
141	2	Te mayo director unos realidad elecciones mercado.	32341.15	EUR
141	3	Informe junto técnica niños últimos.	46435.15	EUR
142	1	Generales e libre adelante.	32478.24	USD
143	1	Calidad última hay ve general aquellos asimismo ojos.	27195.15	MXN
144	1	Este europa punto.	18025.63	GBP
144	2	Madrid queda corazón llama.	48638.71	EUR
144	3	Cambio ahora siguientes lópez.	5079.06	CHF
145	1	Van mismo diferentes.	13937.87	USD
145	2	Muerto mucha posibilidad quien participación estado serie ley.	21008.80	GBP
145	3	Servicios podía parís r como yo.	15449.87	MXN
146	1	Banco oro acto finalmente seguir.	40980.19	EUR
146	2	Saber sabe primera.	11744.70	EUR
146	3	Pasa mayor unos alta fiscal propia.	9660.03	MXN
147	1	Anterior vez sentido izquierda importante sean.	33208.56	GBP
147	2	Jóvenes torno no cuarto habla otro mucho.	6215.69	CHF
147	3	Tú seguridad clase recuerdo.	34717.65	CHF
148	1	Quien hijo lucha siete otro.	43631.26	CHF
148	2	Aún ejército aspectos presenta puso sector nivel.	30612.74	USD
149	1	Libros luis resulta tenemos mujeres derecha.	11811.31	EUR
149	2	Contra esas papel suficiente capacidad te esfuerzo.	10992.01	CHF
150	1	Realidad médico fuera policía cámara trabajo perdido.	8626.43	USD
150	2	Muestra miembros presidente nuevas ya alguna.	36760.78	CAD
151	1	Casos peor todos salida campo es.	8268.38	CAD
151	2	Buen era aún cosas salud qué.	5590.86	USD
152	1	Sobre serán pone debía texto.	10066.37	USD
152	2	Material primeras supuesto principal alrededor quiere.	10254.14	CAD
153	1	Principio población metros campaña vez hacer obras valores.	9839.93	EUR
153	2	Puso diversos actividad pedro jóvenes.	2031.32	USD
153	3	Carlos estilo niño flores mano primeras don.	44377.40	CAD
154	1	Gobierno cuerpo ministerio orden comisión.	30783.28	MXN
154	2	Nosotros siglo obra resulta sola por partir sur.	8032.60	CAD
154	3	Hija sector para se todo.	13017.44	CHF
155	1	Sigue exterior usted puede diversos pueblo.	5911.46	GBP
155	2	Causa jamás mediante problemas llegado carlos comunidad guerra.	7727.27	MXN
156	1	Algunos secretario está presidente.	5886.77	CAD
156	2	Cosas sociales mediante.	2015.08	MXN
156	3	También región así quería cinco problemas.	38408.84	CHF
157	1	Televisión era tu hacer sociales estos.	7476.77	MXN
158	1	Allí paso acción unidad.	7989.14	CHF
158	2	Ese actual tú pero importantes total.	30382.22	MXN
159	1	Presenta pesar semanas cuanto sobre fuerza.	27576.14	EUR
160	1	Precios ii sus color pasó.	5163.29	USD
160	2	Vivir médico nuestras viaje visita interior b.	24540.85	GBP
160	3	Música somos te después.	44727.12	USD
161	1	García somos origen corazón resultado.	17256.06	USD
161	2	Hija decisión porque mes.	12946.63	GBP
162	1	Económica trata muchos libre ii quienes atrás.	14105.38	GBP
162	2	Realidad hemos aquellas realizar imagen constitución.	7030.70	MXN
162	3	Tengo propia control posibilidades resulta conocer.	6037.95	EUR
163	1	Llegado proceso llamado diversas particular centro armas.	26065.58	CAD
164	1	Iglesia conocer europea aquella unos fondo prensa todas.	1059.31	USD
165	1	Mismos psoe revolución junio una hacia muerte.	12107.08	CAD
166	1	Espera futuro mundo zonas período o aquí.	18312.19	EUR
167	1	Esto santiago grado lópez.	46162.85	CHF
168	1	Mientras ve número cuanto pesetas suerte.	34651.55	CHF
168	2	Principal francisco afirmó muy modelo igual.	41316.46	MXN
169	1	Debía blanco carta cultura alrededor i conocimiento.	9308.39	MXN
169	2	Profesional obstante hace cama naturaleza único suelo interior.	12001.60	EUR
170	1	Misma quedó problema lejos lado figura.	4738.21	EUR
170	2	Manuel presenta cine.	6799.20	MXN
171	1	Verdad campo alrededor jamás también deseo.	30620.81	USD
172	1	Salud alguna hacerlo hemos esas.	26993.55	GBP
172	2	Les nosotros media considera.	9886.91	CAD
173	1	Visita carlos teatro forma sentido.	44762.76	CHF
174	1	Nacional agua aumento mitad ha.	31613.16	EUR
174	2	Lenguaje televisión atrás.	18070.90	MXN
175	1	Necesario unidad único.	45895.48	CHF
175	2	Pacientes civil consecuencia políticos principios.	19086.51	EUR
176	1	Grado vivir has algo voluntad.	40135.49	MXN
176	2	Ojos entrar niveles régimen ante libro te.	43223.98	USD
176	3	Principales señor sociales muchas origen.	39111.42	USD
177	1	Boca e crecimiento área ser mundo ejército.	8241.23	CAD
177	2	Algún consumo sur marco cuando económico los.	36345.83	CAD
178	1	Plan tribunal hizo juan.	6545.04	CAD
179	1	Política cuba conocimiento tú dentro militares suficiente.	14645.33	MXN
179	2	El donde mar haber nueva.	16829.62	USD
179	3	Crecimiento decía blanco tu empresa popular.	9911.74	CAD
180	1	Sectores prueba militares existencia.	16646.47	CAD
180	2	Europea presencia persona cerca gran poco razones.	24583.14	CAD
181	1	Ambos deben final medios misma.	39881.58	EUR
181	2	Línea segunda hijo mientras contenido prueba.	7772.84	CHF
181	3	Elecciones puedo me mujeres ejemplo ocasión fondo.	46158.64	CAD
182	1	Psoe información algún niños arte última esfuerzo.	27917.62	GBP
182	2	Capacidad estados ayuda muy datos.	27154.76	GBP
183	1	Miguel aquí aún hubo encuentran.	41248.81	CAD
183	2	Mesa quien televisión suficiente como interior libros luz.	5097.27	CHF
183	3	Materia allá bastante juego tengo dentro.	21670.20	GBP
184	1	Aumento antonio formación junto.	40753.31	USD
184	2	Debía mayoría acuerdo conocimiento.	35451.57	USD
184	3	Todo lo concepto.	18723.76	USD
185	1	Economía enero fue tú.	18757.52	CAD
186	1	Proceso psoe final.	46124.30	MXN
187	1	Dejó aspectos calle estoy vía.	18682.07	USD
187	2	Pregunta otro prensa enfermedad consecuencia.	15440.17	USD
188	1	No s conocer.	48619.16	CAD
188	2	Sido energía niños principios.	12882.37	USD
188	3	Programas medios miedo manos etc.	3737.42	USD
189	1	Nombre siete aquellos cabeza.	48140.55	CHF
190	1	Horas camino dar verdad.	19495.58	MXN
191	1	Sociales vista niveles principales marzo fecha quería.	48280.75	EUR
191	2	Posible hicieron servicio sentido único contrario sangre.	3650.08	MXN
191	3	Mejor origen hace importancia parece semanas.	33474.62	MXN
192	1	Cuerpo trabajo alta soy participación sol lado materia.	42034.42	USD
192	2	Demás carta período todo francia.	2479.10	EUR
193	1	Seis y compañía mitad producto alguien primero encima.	4870.67	MXN
194	1	Visto educación voy modelo conocimiento distintas.	28889.97	CAD
195	1	Ambiente zona alrededor estas actitud aquí.	38505.47	CAD
196	1	Zonas estos considera comunidad objetivo crisis.	7865.51	GBP
196	2	Deja queda ciento segundo.	35229.63	EUR
196	3	Explicó cuarto aspecto meses real dicen.	24039.04	CHF
197	1	Muestra trabajo recursos noche cuyo quería juego.	22754.71	CHF
197	2	Mes fuera proyecto sean n.	35067.10	EUR
198	1	Nunca ocho soy algún.	8638.48	CHF
199	1	Debe uno larga cosa.	30604.51	USD
200	1	Nuestro sí etc dijo hubo.	8857.09	CAD
200	2	Luego ahí estudios ley pueda trabajar hora mejores.	41801.32	CHF
200	3	Experiencia largo elementos dio madre encuentra.	47463.86	CAD
\.


--
-- TOC entry 3606 (class 0 OID 57369)
-- Dependencies: 235
-- Data for Name: desglose_norm; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.desglose_norm (id_reporte, renglon, descripcion, monto) FROM stdin;
1001	1	Compra de inmueble en efectivo	1850000.00
1001	2	Adquisicion de vehiculo blindado	950000.00
1002	1	Transferencia internacional	2400000.00
1003	1	Compra de joyeria de alto valor	620000.00
\.


--
-- TOC entry 3604 (class 0 OID 57354)
-- Dependencies: 233
-- Data for Name: entidad_norm; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entidad_norm (id_notario, nombre_institucion, sector_economico) FROM stdin;
54	Notaria Publica No. 182	Servicios (Sector 54)
71	Notaria Publica No. 45	Servicios (Sector 54)
\.


--
-- TOC entry 3595 (class 0 OID 16843)
-- Dependencies: 224
-- Data for Name: entidad_reportante; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.entidad_reportante (id_notario, nombre_institucion, sector_economico) FROM stdin;
1	Despacho Candelaria y Alcala SA de CV	Activos Virtuales y Fintech
2	Villaseñor-Esquibel SA de CV	Juegos con Apuesta y Sorteos
3	Laboratorios Saucedo-Hidalgo SA de CV	Metales Preciosos y Joyería
4	Pérez-Rosales e Hijos SA de CV	Activos Virtuales y Fintech
5	Escamilla y Guerra S.A. SA de CV	Notarial y Fe Pública
6	Balderas S.A. SA de CV	Notarial y Fe Pública
7	Industrias Pulido Serna y Muñiz SA de CV	Activos Virtuales y Fintech
8	Industrias Toro Concepción y Contreras SA de CV	Metales Preciosos y Joyería
9	Mares y Zavala S.A. de C.V. SA de CV	Metales Preciosos y Joyería
10	Corporacin Aguilera Sisneros y Villa SA de CV	Metales Preciosos y Joyería
11	Despacho Granados-Sarabia SA de CV	Metales Preciosos y Joyería
12	Pichardo S.A. de C.V. SA de CV	Activos Virtuales y Fintech
13	Grupo Ferrer y Barrientos SA de CV	Juegos con Apuesta y Sorteos
14	Esparza-Rolón e Hijos SA de CV	Activos Virtuales y Fintech
15	Zapata y Meraz y Asociados SA de CV	Vehículos y Blindaje
16	Luna-Peralta S.A. de C.V. SA de CV	Inmobiliario y Construcción
17	Despacho Rentería-Arias SA de CV	Bancario y Financiero
18	Gaona y Acosta e Hijos SA de CV	Metales Preciosos y Joyería
19	Laboratorios Godínez y Robledo SA de CV	Notarial y Fe Pública
20	Grupo Rosales y Meraz SA de CV	Activos Virtuales y Fintech
21	Flórez Pabón y Enríquez SA de CV	Bancario y Financiero
22	Naranjo A.C. SA de CV	Vehículos y Blindaje
23	Muñiz-Anguiano SA de CV	Activos Virtuales y Fintech
24	Collado-López SA de CV	Juegos con Apuesta y Sorteos
25	Esquivel y Vigil y Asociados SA de CV	Bancario y Financiero
26	Armas-Anguiano S.A. SA de CV	Bancario y Financiero
27	Corporacin Delgado y Gaona SA de CV	Inmobiliario y Construcción
28	Laboratorios Delgado Mojica y Urrutia SA de CV	Inmobiliario y Construcción
29	Grupo Estévez y Alonzo SA de CV	Metales Preciosos y Joyería
30	Proyectos Iglesias-Campos SA de CV	Activos Virtuales y Fintech
31	Chapa S.C. SA de CV	Notarial y Fe Pública
32	Mireles-Gaitán SA de CV	Metales Preciosos y Joyería
33	Club Grijalva Negrón y Nieves SA de CV	Bancario y Financiero
34	Industrias Puente-Barragán SA de CV	Metales Preciosos y Joyería
35	Colón-Cedillo SA de CV	Activos Virtuales y Fintech
36	Grupo Tejada y Ochoa SA de CV	Bancario y Financiero
37	Matías-Zamudio S.C. SA de CV	Vehículos y Blindaje
38	Despacho Villagómez y Esparza SA de CV	Vehículos y Blindaje
39	Proyectos Córdova Menchaca y Gutiérrez SA de CV	Notarial y Fe Pública
40	Lemus y Asociados SA de CV	Juegos con Apuesta y Sorteos
41	Proyectos Sauceda-Viera SA de CV	Bancario y Financiero
42	Fuentes y Bonilla y Asociados SA de CV	Vehículos y Blindaje
43	Barragán y de la Fuente S. R.L. de C.V. SA de CV	Vehículos y Blindaje
44	Saucedo Noriega y Samaniego SA de CV	Activos Virtuales y Fintech
45	Duarte y Medina e Hijos SA de CV	Vehículos y Blindaje
46	Sotelo-Rosas e Hijos SA de CV	Juegos con Apuesta y Sorteos
47	Rojo y Jasso S. R.L. de C.V. SA de CV	Inmobiliario y Construcción
48	Vergara Arce y Franco SA de CV	Metales Preciosos y Joyería
49	Grupo Razo y Gollum SA de CV	Metales Preciosos y Joyería
50	Gamez Malave y Pizarro SA de CV	Vehículos y Blindaje
51	Vázquez Cortez y Noriega SA de CV	Vehículos y Blindaje
52	Industrias Bravo Cervantes y Bravo SA de CV	Juegos con Apuesta y Sorteos
53	Club Solano Mora y Godínez SA de CV	Activos Virtuales y Fintech
54	Rivero S. R.L. de C.V. SA de CV	Inmobiliario y Construcción
55	Polanco-Raya S.C. SA de CV	Vehículos y Blindaje
56	Paredes Nazario y Salinas SA de CV	Vehículos y Blindaje
57	Laboy-Olivas A.C. SA de CV	Inmobiliario y Construcción
58	Club González-Jaimes SA de CV	Inmobiliario y Construcción
59	Muñoz-Borrego SA de CV	Bancario y Financiero
60	Proyectos Sánchez Serna y Treviño SA de CV	Activos Virtuales y Fintech
61	Lebrón-Gil SA de CV	Inmobiliario y Construcción
62	Casanova-Becerra SA de CV	Juegos con Apuesta y Sorteos
63	Arellano-Treviño S.A. SA de CV	Juegos con Apuesta y Sorteos
64	Estrada-Mendoza S.A. de C.V. SA de CV	Notarial y Fe Pública
65	Laboratorios Laureano Espino y Zayas SA de CV	Vehículos y Blindaje
66	Proyectos Tórrez-Ibarra SA de CV	Metales Preciosos y Joyería
67	Luna S.A. de C.V. SA de CV	Metales Preciosos y Joyería
68	Páez-Palomino y Asociados SA de CV	Vehículos y Blindaje
69	Rodríquez e Hijos SA de CV	Notarial y Fe Pública
70	Proyectos Otero-Gil SA de CV	Juegos con Apuesta y Sorteos
71	Laboratorios Fuentes y Rojo SA de CV	Juegos con Apuesta y Sorteos
72	Industrias Villagómez y Urías SA de CV	Activos Virtuales y Fintech
73	Riojas y Molina y Asociados SA de CV	Juegos con Apuesta y Sorteos
74	Marroquín-Escobedo SA de CV	Vehículos y Blindaje
75	Perales Fuentes y Quiñones SA de CV	Metales Preciosos y Joyería
76	Valdez y Anguiano S.A. de C.V. SA de CV	Vehículos y Blindaje
77	Industrias Cazares-Magaña SA de CV	Inmobiliario y Construcción
78	Sanabria y Asociados SA de CV	Activos Virtuales y Fintech
79	Mojica-Garza S.C. SA de CV	Activos Virtuales y Fintech
80	Páez Terrazas y Luna SA de CV	Vehículos y Blindaje
81	Villagómez-Altamirano S. R.L. de C.V. SA de CV	Metales Preciosos y Joyería
82	Chávez S.A. SA de CV	Activos Virtuales y Fintech
83	Vanegas-Zavala S. R.L. de C.V. SA de CV	Notarial y Fe Pública
84	Olivárez Flores y Ornelas SA de CV	Inmobiliario y Construcción
85	Téllez-Olvera SA de CV	Bancario y Financiero
86	Club Cardona y Méndez SA de CV	Bancario y Financiero
87	Maestas y Cabán S.A. SA de CV	Juegos con Apuesta y Sorteos
88	Uribe-Díaz SA de CV	Inmobiliario y Construcción
89	Zavala S.C. SA de CV	Metales Preciosos y Joyería
90	Escobar S.A. SA de CV	Vehículos y Blindaje
91	Olvera-Limón SA de CV	Vehículos y Blindaje
92	Grupo Lovato y Soria SA de CV	Vehículos y Blindaje
93	Rentería-Báez SA de CV	Notarial y Fe Pública
94	Sisneros-Alba S.A. SA de CV	Juegos con Apuesta y Sorteos
95	Partida-Ornelas S.A. SA de CV	Juegos con Apuesta y Sorteos
96	Ceballos-Terán SA de CV	Inmobiliario y Construcción
97	Romo Barrientos y Ordóñez SA de CV	Notarial y Fe Pública
98	Grupo Flórez y Marín SA de CV	Bancario y Financiero
99	Roldán Covarrubias y Zayas SA de CV	Juegos con Apuesta y Sorteos
100	Industrias Fierro Sandoval y Reynoso SA de CV	Juegos con Apuesta y Sorteos
101	Grupo Aguilar Collazo y Ramírez SA de CV	Inmobiliario y Construcción
102	Ozuna-Zedillo SA de CV	Juegos con Apuesta y Sorteos
103	Industrias Méndez y Varela SA de CV	Inmobiliario y Construcción
104	Rincón y Ríos S. R.L. de C.V. SA de CV	Activos Virtuales y Fintech
105	Bustos S.A. de C.V. SA de CV	Vehículos y Blindaje
106	Montenegro y Luevano S.C. SA de CV	Notarial y Fe Pública
107	Club Haro-Duarte SA de CV	Bancario y Financiero
108	Reyna Olivo y Elizondo SA de CV	Bancario y Financiero
109	Orozco-Armas SA de CV	Activos Virtuales y Fintech
110	Proyectos Cotto y Lara SA de CV	Juegos con Apuesta y Sorteos
111	Laboratorios Barrera Gamboa y Salcido SA de CV	Juegos con Apuesta y Sorteos
112	Uribe Casas y Negrete SA de CV	Inmobiliario y Construcción
113	Cantú-Santana SA de CV	Notarial y Fe Pública
114	Parra-Raya S.A. SA de CV	Activos Virtuales y Fintech
115	Grupo Santillán Armendáriz y Ríos SA de CV	Activos Virtuales y Fintech
116	Beltrán e Hijos SA de CV	Inmobiliario y Construcción
117	Olivárez y Montalvo e Hijos SA de CV	Vehículos y Blindaje
118	Esquivel Osorio y Archuleta SA de CV	Metales Preciosos y Joyería
119	Henríquez A.C. SA de CV	Juegos con Apuesta y Sorteos
120	Corporacin Rivera-Rubio SA de CV	Bancario y Financiero
121	Barreto y Borrego S. R.L. de C.V. SA de CV	Vehículos y Blindaje
122	Laboratorios Quezada y Cintrón SA de CV	Bancario y Financiero
123	Leiva y Cuellar S.A. SA de CV	Activos Virtuales y Fintech
124	Zepeda A.C. SA de CV	Inmobiliario y Construcción
125	Corporacin Castellanos-Téllez SA de CV	Inmobiliario y Construcción
126	de la Garza Bernal y Alba SA de CV	Vehículos y Blindaje
127	Grupo Quintana Muñiz y Domínguez SA de CV	Juegos con Apuesta y Sorteos
128	Laboratorios Aragón y Tejada SA de CV	Inmobiliario y Construcción
129	Club Arreola y Solorzano SA de CV	Bancario y Financiero
130	Orellana-Manzanares SA de CV	Bancario y Financiero
131	Ávila y Zamora A.C. SA de CV	Activos Virtuales y Fintech
132	Ocasio y Asociados SA de CV	Vehículos y Blindaje
133	Grupo Noriega y Griego SA de CV	Bancario y Financiero
134	Despacho Alemán y Pérez SA de CV	Metales Preciosos y Joyería
135	Alcaraz S.A. de C.V. SA de CV	Inmobiliario y Construcción
136	Laboratorios Barajas y Garay SA de CV	Juegos con Apuesta y Sorteos
137	de la Fuente-de la Fuente SA de CV	Vehículos y Blindaje
138	Pelayo S. R.L. de C.V. SA de CV	Bancario y Financiero
139	Mena-Medrano SA de CV	Metales Preciosos y Joyería
140	Industrias Franco y Toro SA de CV	Inmobiliario y Construcción
141	Porras Casárez y Gómez SA de CV	Notarial y Fe Pública
142	Despacho Munguía y Mejía SA de CV	Activos Virtuales y Fintech
143	Despacho Padilla-Mata SA de CV	Vehículos y Blindaje
144	Ordóñez S.A. SA de CV	Juegos con Apuesta y Sorteos
145	Garay y Barraza e Hijos SA de CV	Juegos con Apuesta y Sorteos
146	Laboratorios Negrete Armas y Barrera SA de CV	Vehículos y Blindaje
147	Club Madera y Zamudio SA de CV	Vehículos y Blindaje
148	Canales y Terán y Asociados SA de CV	Vehículos y Blindaje
149	Corporacin Cadena-Zapata SA de CV	Juegos con Apuesta y Sorteos
150	Oquendo-Cepeda S.A. de C.V. SA de CV	Activos Virtuales y Fintech
151	Laboratorios Matías-Rosario SA de CV	Juegos con Apuesta y Sorteos
152	Meza-Almanza SA de CV	Notarial y Fe Pública
153	Olivas y Segura e Hijos SA de CV	Inmobiliario y Construcción
154	Industrias Villagómez y Alcántar SA de CV	Inmobiliario y Construcción
155	Despacho Castellanos y Mares SA de CV	Inmobiliario y Construcción
156	Laboratorios Porras y Guerrero SA de CV	Vehículos y Blindaje
157	Balderas-Chapa SA de CV	Activos Virtuales y Fintech
158	Samaniego-Lucio S.A. SA de CV	Activos Virtuales y Fintech
159	Club Flores-Archuleta SA de CV	Vehículos y Blindaje
160	Laboratorios Zamora y Quiroz SA de CV	Juegos con Apuesta y Sorteos
161	Cervantes-Ledesma S.A. de C.V. SA de CV	Vehículos y Blindaje
162	Soliz y Asociados SA de CV	Notarial y Fe Pública
163	Lomeli Alva y Girón SA de CV	Vehículos y Blindaje
164	Monroy-Guerra S.A. SA de CV	Metales Preciosos y Joyería
165	Guzmán y Asociados SA de CV	Juegos con Apuesta y Sorteos
166	Industrias Olivárez y Soliz SA de CV	Vehículos y Blindaje
167	Elizondo-Quintanilla e Hijos SA de CV	Notarial y Fe Pública
168	Barragán y Asociados SA de CV	Bancario y Financiero
169	Barrios y Espinoza A.C. SA de CV	Inmobiliario y Construcción
170	Grupo Castillo-Bustos SA de CV	Juegos con Apuesta y Sorteos
171	Industrias Ulloa-Flores SA de CV	Juegos con Apuesta y Sorteos
172	Industrias Berríos y Polanco SA de CV	Notarial y Fe Pública
173	Márquez y de Anda e Hijos SA de CV	Activos Virtuales y Fintech
174	Grupo Pineda y del Valle SA de CV	Activos Virtuales y Fintech
175	Corporacin Lira y Velázquez SA de CV	Inmobiliario y Construcción
176	Ferrer y Jurado y Asociados SA de CV	Metales Preciosos y Joyería
177	Bétancourt y Murillo S.C. SA de CV	Bancario y Financiero
178	de la Fuente Rodríguez y Quintana SA de CV	Notarial y Fe Pública
179	Santiago Prieto y Cortés SA de CV	Vehículos y Blindaje
180	Almonte y Olivárez S.C. SA de CV	Metales Preciosos y Joyería
181	Macías-Yáñez SA de CV	Activos Virtuales y Fintech
182	Industrias del Río-Hinojosa SA de CV	Metales Preciosos y Joyería
183	Rivas Malave y Rendón SA de CV	Bancario y Financiero
184	Club Valenzuela Zelaya y Rosales SA de CV	Bancario y Financiero
185	Merino-Chacón SA de CV	Bancario y Financiero
186	Estévez y Correa S.A. SA de CV	Metales Preciosos y Joyería
187	Alcántar y Asociados SA de CV	Notarial y Fe Pública
188	Salazar-Palacios S.C. SA de CV	Metales Preciosos y Joyería
189	Niño Olivo y Saiz SA de CV	Notarial y Fe Pública
190	Laboratorios Villalobos Batista y Paredes SA de CV	Metales Preciosos y Joyería
191	Castellanos S.C. SA de CV	Bancario y Financiero
192	Grupo Pulido-Herrera SA de CV	Inmobiliario y Construcción
193	Saucedo-Sáenz e Hijos SA de CV	Vehículos y Blindaje
194	Baeza-Olmos S.C. SA de CV	Juegos con Apuesta y Sorteos
195	Grupo Romo y Aragón SA de CV	Metales Preciosos y Joyería
196	Amaya-Cordero S.A. de C.V. SA de CV	Juegos con Apuesta y Sorteos
197	Contreras y Hernández S.A. SA de CV	Juegos con Apuesta y Sorteos
198	Despacho Carrión-Caballero SA de CV	Juegos con Apuesta y Sorteos
199	Otero Villa y Blanco SA de CV	Activos Virtuales y Fintech
200	Club de Jesús y Ponce SA de CV	Metales Preciosos y Joyería
9001	Notaria Publica No. 182 de la CDMX	Notarial y Fe Pública
\.


--
-- TOC entry 3601 (class 0 OID 16916)
-- Dependencies: 230
-- Data for Name: expediente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.expediente (num_expediente, id_alerta, fecha_apertura, fiscal_asignado) FROM stdin;
1	176	2026-10-31	Violeta Cantú Muñoz
2	38	2026-10-31	Luis Miguel Nicolás Mesa Miramontes
3	120	2026-10-31	Esteban José Carlos Malave
4	175	2026-10-31	Natividad Cristina Alonzo Quiñones
5	39	2026-10-31	Paulina Olivia Puga Ozuna
6	134	2026-10-31	Gilberto Niño
7	75	2026-10-31	María Teresa Pacheco Macías
8	160	2026-10-31	Patricio Cardenas
9	143	2026-10-31	Estela Olivia Pacheco
10	171	2026-10-31	Emiliano Sepúlveda de la Crúz
11	42	2026-10-31	Lic. Daniela Vanegas
12	78	2026-10-31	Joaquín Amador Bustamante Mares
13	125	2026-10-31	María Cristina Ortiz de Jesús
14	74	2026-10-31	Diego Fernández de León
15	17	2026-10-31	Sr. Esteban Gracia
16	76	2026-10-31	Arcelia Zoé Guevara
17	4	2026-10-31	Jaqueline Adame
18	117	2026-10-31	Jorge Luis Bruno Rodríguez Urbina
19	11	2026-10-31	Modesto Ocampo
20	56	2026-10-31	Bernardo Ontiveros
21	73	2026-10-31	Carla Pabón Mena
22	152	2026-10-31	Perla Karina Tejeda
23	32	2026-10-31	Marisela Villa Amador
24	14	2026-10-31	Srita. Elsa Negrete
25	126	2026-10-31	Martha Abreu Zamudio
26	79	2026-10-31	Gabino Darío Sanabria
27	2	2026-10-31	Fidel Madrid Puga
28	111	2026-10-31	Judith Dueñas Pizarro
29	91	2026-10-31	Ing. Julio Rosales
30	170	2026-10-31	Lic. Ernesto Dávila
31	1	2026-10-31	Barbara Rivero
32	13	2026-10-31	Úrsula Campos Palacios
33	65	2026-10-31	Jaime Cristian Velasco Sarabia
34	36	2026-10-31	Adela Mariana Padilla Pichardo
35	90	2026-10-31	Lic. Gregorio Carrillo
36	180	2026-10-31	Martha Jaqueline Rojas Meza
37	129	2026-10-31	Beatriz Duarte Pineda
38	144	2026-10-31	Tania Angélica Cornejo
39	40	2026-10-31	Wendolin Villanueva Holguín
40	23	2026-10-31	Rocío Rentería
41	70	2026-10-31	Miguel Lerma Arenas
42	37	2026-10-31	María Cristina Itzel Arteaga Zamudio
43	51	2026-10-31	Lic. Jonás Lucio
44	173	2026-10-31	Estela Duarte
45	150	2026-10-31	Liliana Alfaro Ramón
46	21	2026-10-31	Sr. Teodoro Carrasco
47	194	2026-10-31	Renato Ortiz Guzmán
48	57	2026-10-31	Renato Bernardo Castro
49	9	2026-10-31	Lucía Esther Montaño Reynoso
50	122	2026-10-31	Ramón Varela
51	172	2026-10-31	Augusto Mena Nieves
52	64	2026-10-31	Uriel Bruno Olivas Sepúlveda
53	99	2026-10-31	Sandra Madrid Pichardo
54	109	2026-10-31	Esteban Hinojosa Bétancourt
55	103	2026-10-31	Evelio Salvador Ibarra
56	26	2026-10-31	Lic. Natalia Guerrero
57	67	2026-10-31	Olga Rojas Galván
58	189	2026-10-31	Dr. Hernán Sánchez
59	80	2026-10-31	Ing. Cristal Linares
60	45	2026-10-31	Lucas Franco Almaraz
61	112	2026-10-31	Hernán Gustavo Ríos Zamudio
62	83	2026-10-31	Ariadna García Garza
63	167	2026-10-31	Dulce María Barela Loera
64	52	2026-10-31	Patricia Linda Yáñez Méndez
65	168	2026-10-31	María José Noelia Alcala
66	35	2026-10-31	Guadalupe Montemayor Rael
67	107	2026-10-31	Marisol Diana Tejada de la Rosa
68	137	2026-10-31	Lic. Alejandro Vázquez
69	192	2026-10-31	Noemí Inés Botello Franco
70	197	2026-10-31	Gabriela Lovato Mascareñas
71	22	2026-10-31	Alicia Cecilia Viera de la Crúz
72	77	2026-10-31	Norma Prado Pelayo
73	119	2026-10-31	Lic. Genaro Núñez
74	193	2026-10-31	José María Uriel Castañeda Calderón
75	24	2026-10-31	Fidel Carranza
76	49	2026-10-31	Dr. Eloy Pacheco
77	101	2026-10-31	Irma Dulce Peralta
78	113	2026-10-31	Ing. José Eduardo Caraballo
79	195	2026-10-31	Martha Tello Tejada
80	181	2026-10-31	Lorenzo Saldaña
81	169	2026-10-31	Lic. Eloy Díaz
82	18	2026-10-31	Sr. Renato Mesa
83	68	2026-10-31	Bruno Juan Carlos Vera Peralta
84	153	2026-10-31	Cynthia Salma Anaya
85	89	2026-10-31	Darío Santacruz
86	41	2026-10-31	Lic. Leticia Altamirano
87	136	2026-10-31	Srita. Clara Varela
88	88	2026-10-31	Úrsula Arcelia Nevárez Altamirano
89	92	2026-10-31	Nelly Mercedes Espinoza
90	46	2026-10-31	Ivonne Zoé Grijalva del Río
91	60	2026-10-31	Javier Centeno
92	157	2026-10-31	Aldo Felix Vélez
93	55	2026-10-31	Elvira Úrsula Zavala Quiroz
94	110	2026-10-31	Miguel Pascual Carranza Zayas
95	54	2026-10-31	Germán Miguel Barrios Aguilar
96	53	2026-10-31	Miriam María Eugenia Olmos
97	151	2026-10-31	Esperanza Yolanda Terrazas
98	184	2026-10-31	Lic. Yeni Alva
99	72	2026-10-31	Zoé Ana María Loya Otero
100	146	2026-10-31	Laura Segura Quiñónez
101	148	2026-10-31	Camilo Diego Iglesias
102	106	2026-10-31	Enrique José Emilio Paz
103	12	2026-10-31	Carmen Guerra Rosas
104	97	2026-10-31	Sr. Jesús Benavides
105	128	2026-10-31	Elvira Esperanza Monroy Lucero
106	131	2026-10-31	Margarita Holguín Vanegas
107	196	2026-10-31	Sra. Carlota Cordero
108	178	2026-10-31	Sr. Francisco Nevárez
109	154	2026-10-31	Yeni Lovato Maldonado
110	66	2026-10-31	Dra. María José Quiñónez
111	48	2026-10-31	Cristian Diego Zúñiga Loya
112	186	2026-10-31	Dr. Aldo Galarza
113	142	2026-10-31	Dr. Serafín Alcala
114	127	2026-10-31	Yuridia Sauceda Sierra
115	165	2026-10-31	Rosa Claudia Montañez Cortés
116	199	2026-10-31	Graciela Solorzano
117	7	2026-10-31	Mariana Sessa de la O
118	158	2026-10-31	Concepción María Teresa Ojeda Alcaraz
119	116	2026-10-31	Elena Mares Fonseca
120	133	2026-10-31	Homero Uriel Casares Estrada
121	191	2026-10-31	María Cristina Ofelia Alcala Soria
122	104	2026-10-31	José Emilio Apodaca
123	163	2026-10-31	Jesús Patricio Barrera
124	59	2026-10-31	Nadia Terrazas
125	84	2026-10-31	Mateo Valverde Solorzano
126	182	2026-10-31	Gonzalo Elizondo
127	8	2026-10-31	Gabino Reyes
128	135	2026-10-31	Uriel Jáquez Urías
129	177	2026-10-31	Eugenio Antonio Centeno
130	43	2026-10-31	Sr. Fernando Gil
131	198	2026-10-31	Lic. María Luisa Rivera
132	85	2026-10-31	Ana Matos
133	62	2026-10-31	Federico Octavio Carrión
134	71	2026-10-31	Nicolás Federico Camarillo
135	187	2026-10-31	Srita. Pilar Ruiz
136	16	2026-10-31	Sra. Pamela Posada
137	185	2026-10-31	Sara Dalia Villalpando Reyes
138	141	2026-10-31	Lic. Timoteo Juárez
139	102	2026-10-31	Jesús Patricio Rosas Serrano
140	34	2026-10-31	Ing. Renato Guzmán
141	10	2026-10-31	Ing. Zeferino Quiñónez
142	138	2026-10-31	Omar Abelardo Matos Saucedo
143	166	2026-10-31	Citlali Conchita Barraza Preciado
144	93	2026-10-31	Martín Jorge Tijerina
145	179	2026-10-31	Carlos Gómez
146	15	2026-10-31	Ing. Jaime Tamez
147	44	2026-10-31	Isaac Vicente Gaitán
148	115	2026-10-31	Javier Eloy Espinosa Ortiz
149	95	2026-10-31	Vicente Eloy Melgar Sevilla
150	20	2026-10-31	Ing. Zoé Jiménez
151	105	2026-10-31	Lic. Israel Nevárez
152	139	2026-10-31	Ing. José Mascareñas
153	47	2026-10-31	Lic. Rubén Orozco
154	123	2026-10-31	Lorenzo Baca Paredes
155	183	2026-10-31	Mauro Hernán Almaraz Fierro
156	162	2026-10-31	Ing. José Manuél Alva
157	87	2026-10-31	Juana Helena Valdez
158	156	2026-10-31	Flavio Santacruz
159	5	2026-10-31	Sr. Augusto Guerra
160	58	2026-10-31	Zoé Rosado Villaseñor
161	81	2026-10-31	Julio Ruiz Haro
162	94	2026-10-31	Lic. Josefina Bahena
163	132	2026-10-31	Jorge Leal Terrazas
164	61	2026-10-31	Eva Beatriz Rodríquez Cervantes
165	149	2026-10-31	Lilia Coronado Corona
166	114	2026-10-31	Dr. Rolando Bueno
167	118	2026-10-31	Jerónimo Vega
168	164	2026-10-31	Ing. Agustín Cintrón
169	31	2026-10-31	Isabela Ramírez Gallegos
170	50	2026-10-31	María Elena Gil Rincón
171	27	2026-10-31	Daniela Huerta Herrera
172	82	2026-10-31	Darío Casares Partida
173	108	2026-10-31	Mariana Amelia Tafoya
174	100	2026-10-31	Jaqueline Alemán
175	174	2026-10-31	Alma Mayte Mena
176	124	2026-10-31	Eva Olivia Merino Barrera
177	63	2026-10-31	Sra. Noelia Carreón
178	30	2026-10-31	Porfirio Benjamín Vela Rocha
179	86	2026-10-31	Arturo Prado
180	6	2026-10-31	Margarita Catalina Menéndez Beltrán
181	69	2026-10-31	Dra. María Suárez
182	96	2026-10-31	Leonel Velasco Lozada
183	121	2026-10-31	Ing. Aida Aguilera
184	28	2026-10-31	Lourdes Corona Huerta
185	25	2026-10-31	Dra. Nadia Reyna
186	33	2026-10-31	Samuel Mota
187	3	2026-10-31	Eugenio Diego Fonseca Manzanares
188	140	2026-10-31	Alberto Renato Zarate
189	147	2026-10-31	Reynaldo Jos Barrientos Menchaca
190	159	2026-10-31	Fernando Ferrer
191	161	2026-10-31	Manuel Héctor Gonzales Gamboa
192	130	2026-10-31	Darío Quiñónez Castañeda
193	200	2026-10-31	Martín Frías Olivares
194	190	2026-10-31	Luz Laura Farías Flórez
195	155	2026-10-31	Sra. Arcelia del Río
196	29	2026-10-31	Lic. Blanca Curiel
197	145	2026-10-31	Óscar Tomás Muñiz
198	19	2026-10-31	Cynthia Diana Bustamante
199	188	2026-10-31	María Luisa Herrera Sauceda
200	98	2026-10-31	Aida Abril Olivares Peres
\.


--
-- TOC entry 3592 (class 0 OID 16816)
-- Dependencies: 221
-- Data for Name: lista_bloqueados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lista_bloqueados (id_bloqueo, rfc, fecha_bloqueo, motivo) FROM stdin;
1	WKQE640928759	2025-12-15	Orden judicial
2	VUK100713RWI	2025-09-22	Financiamiento ilícito
3	GDOB0601131HH	2022-12-06	Financiamiento ilícito
4	VWAT560531L72	2026-03-13	Orden judicial
5	WVGU600626D54	2026-05-01	Operaciones inusuales
6	PPM970223B7F	2022-11-01	Operaciones inusuales
7	AFC990104BVZ	2023-08-22	Fraude fiscal
8	AYVQ6312282EK	2025-09-14	Financiamiento ilícito
9	VELK920216YIP	2025-11-09	Orden judicial
10	DNTE520915HR0	2022-02-09	Fraude fiscal
11	BLK260323RCJ	2023-03-02	Operaciones inusuales
12	HKIP7110212XC	2026-08-02	Fraude fiscal
13	DNOU980212GC5	2024-12-21	Fraude fiscal
14	GMR0005103OD	2022-11-03	Orden judicial
15	BDDE710412LZM	2025-04-22	Fraude fiscal
16	QAHF8905070Y6	2022-10-08	Orden judicial
17	JGC981127U0I	2022-11-10	Financiamiento ilícito
18	YJY130510LA1	2024-12-22	Fraude fiscal
19	YBM160915K4L	2026-09-11	Operaciones inusuales
20	GAUI5608060W1	2024-04-17	Operaciones inusuales
21	OAF130120UKW	2022-03-05	Fraude fiscal
22	TRM020628UJO	2026-04-12	Financiamiento ilícito
23	GBG070115DAN	2023-02-19	Operaciones inusuales
24	NRV260916NXV	2022-10-31	Financiamiento ilícito
25	VGVM50050430M	2024-12-28	Fraude fiscal
26	VIJB030209T64	2024-06-04	Financiamiento ilícito
27	SPVO8207163BB	2025-01-06	Orden judicial
28	JXE090922OKZ	2024-05-30	Operaciones inusuales
29	FYWI911119XO6	2024-05-01	Financiamiento ilícito
30	XAS1408148UU	2025-12-18	Operaciones inusuales
31	SBV990222LDI	2022-01-25	Financiamiento ilícito
32	APX190815144	2023-01-17	Operaciones inusuales
33	RVUF521022BLJ	2023-01-15	Operaciones inusuales
34	HBKU681225QD6	2025-06-02	Fraude fiscal
35	CNV100529QSQ	2022-03-31	Financiamiento ilícito
36	ILB260220MAE	2024-06-05	Fraude fiscal
37	BDOH0208059E1	2024-03-29	Operaciones inusuales
38	XSI220713E6K	2023-08-31	Financiamiento ilícito
39	PUFN700829QP4	2023-05-22	Financiamiento ilícito
40	LAY981029HYE	2025-12-27	Orden judicial
41	MPM1312101H6	2021-11-06	Operaciones inusuales
42	EZW070806RLR	2022-11-15	Orden judicial
43	AYZ981101E9R	2026-06-28	Orden judicial
44	MGOO0110049K9	2024-10-18	Financiamiento ilícito
45	JEFY830625RIE	2022-05-28	Orden judicial
46	HKC101027669	2022-03-18	Operaciones inusuales
47	DWLX660221QDY	2025-05-20	Fraude fiscal
48	MWH040428Z36	2025-12-03	Orden judicial
49	TJKO530612HTC	2026-09-15	Orden judicial
50	MOGW600917PHT	2024-06-19	Financiamiento ilícito
51	CLHA5609121WJ	2026-08-23	Financiamiento ilícito
52	TYH0401150AX	2025-09-05	Financiamiento ilícito
53	VJYZ530818QKN	2024-09-14	Fraude fiscal
54	GRP2011305G1	2025-01-15	Financiamiento ilícito
55	TMNM671122LA8	2025-11-15	Operaciones inusuales
56	FXN980308W22	2022-12-17	Operaciones inusuales
57	OWC121130TBH	2023-01-04	Financiamiento ilícito
58	RHOR4801070BV	2026-02-15	Financiamiento ilícito
59	IQX190413DUT	2025-10-02	Fraude fiscal
60	IGD170128FY3	2025-08-28	Fraude fiscal
61	EZS04121472I	2025-08-26	Operaciones inusuales
62	BPNW601101F8C	2023-02-05	Fraude fiscal
63	YWWJ041227F4Z	2024-08-06	Financiamiento ilícito
64	VTRN621210XPN	2022-08-04	Fraude fiscal
65	MSQV460120C1Q	2025-04-25	Financiamiento ilícito
66	DFPT880713XG1	2025-02-15	Operaciones inusuales
67	JJFG5505017XV	2023-10-24	Orden judicial
68	VVE160124V3Z	2025-03-12	Fraude fiscal
69	YIQ9809042LM	2024-09-18	Operaciones inusuales
70	WPUS640719T9N	2026-06-07	Operaciones inusuales
71	NTHZ700714YE9	2022-03-22	Fraude fiscal
72	PGWE860804LUL	2025-08-07	Orden judicial
73	KLT260226IQ2	2024-03-10	Financiamiento ilícito
74	HVZG561214TN7	2022-08-02	Operaciones inusuales
75	HBF0302262VF	2023-03-29	Operaciones inusuales
76	AQDM871204BNH	2022-01-16	Orden judicial
77	BTK080502IH5	2026-09-12	Financiamiento ilícito
78	ESEJ9512149XU	2024-06-16	Operaciones inusuales
79	KQFS481015RIX	2026-08-09	Orden judicial
80	PEH051113YE0	2022-11-19	Fraude fiscal
81	VWZ190929EL8	2026-08-03	Orden judicial
82	SCN020310IRC	2022-07-22	Orden judicial
83	YCAI050801FYO	2023-06-20	Operaciones inusuales
84	KFZN060719DBD	2026-06-10	Financiamiento ilícito
85	SCV040623P15	2026-09-27	Fraude fiscal
86	AJC110331VLN	2022-04-13	Orden judicial
87	XEC120604HGZ	2026-09-06	Fraude fiscal
88	MUNC550723S8B	2026-04-09	Financiamiento ilícito
89	ZVY9903102KK	2023-06-11	Fraude fiscal
90	FHB150905856	2025-11-17	Fraude fiscal
91	OHDR640101Z7S	2026-02-08	Operaciones inusuales
92	CKAF530530SAH	2021-12-27	Financiamiento ilícito
93	EOZ2408194XY	2022-11-08	Orden judicial
94	VMC150723B1K	2026-05-10	Operaciones inusuales
95	DEY07071028X	2023-05-12	Operaciones inusuales
96	OCL150413MRU	2021-12-28	Orden judicial
97	ECLL840110Q0Y	2024-03-03	Financiamiento ilícito
98	COE1502155NQ	2023-08-01	Fraude fiscal
99	RRPV8406067DI	2023-12-02	Financiamiento ilícito
100	EJT990420T6D	2026-10-05	Financiamiento ilícito
101	PANG530604FPW	2025-08-11	Fraude fiscal
102	CXDL670401Y08	2022-07-20	Fraude fiscal
103	RSU210810C9R	2026-05-15	Fraude fiscal
104	JABN961206I9N	2024-07-22	Financiamiento ilícito
105	UWNL6311108CR	2025-04-01	Orden judicial
106	FVLH9710152IA	2022-03-19	Financiamiento ilícito
107	GVK2404226L1	2026-01-04	Orden judicial
108	KTEK600420DRO	2022-01-11	Financiamiento ilícito
109	SED1607152J5	2024-09-21	Orden judicial
110	IPO260402RMY	2025-07-19	Fraude fiscal
111	ITJT0602023JC	2023-05-14	Financiamiento ilícito
112	ZSC98100776S	2025-05-12	Financiamiento ilícito
113	PEG210925UI9	2022-01-13	Operaciones inusuales
114	YJY210314ODK	2026-04-28	Orden judicial
115	VQV260802ZKW	2024-07-13	Financiamiento ilícito
116	EQQV620323FYB	2025-01-29	Financiamiento ilícito
117	SFQG000901R64	2024-01-08	Fraude fiscal
118	GIU251019Z0L	2022-08-09	Orden judicial
119	SYX130101G5G	2022-10-22	Orden judicial
120	IVNS661005K3N	2022-09-04	Financiamiento ilícito
121	OVPD740805EL6	2026-06-10	Orden judicial
122	IMGG451115DKN	2023-04-06	Orden judicial
123	YMS981123PKY	2024-04-04	Orden judicial
124	JRT19050981A	2023-01-21	Orden judicial
125	DOIO640315TQL	2023-05-21	Orden judicial
126	VKA050317YGH	2024-01-02	Operaciones inusuales
127	QILP7302180DK	2022-08-05	Operaciones inusuales
128	JNR191022J9B	2023-02-22	Financiamiento ilícito
129	LJNI48121343D	2024-06-10	Orden judicial
130	ZMMY631004S20	2025-04-18	Fraude fiscal
131	SVKR89052139R	2023-04-09	Financiamiento ilícito
132	FFLA020410MYO	2022-05-02	Financiamiento ilícito
133	WDZ201008P3J	2024-08-06	Orden judicial
134	WXV170621SDY	2023-05-17	Orden judicial
135	BCU100623QE4	2022-01-23	Operaciones inusuales
136	OVV051108PT5	2022-04-30	Financiamiento ilícito
137	EDI110325IJI	2024-05-13	Financiamiento ilícito
138	FKIJ700620Z1U	2025-02-23	Orden judicial
139	ZPYX820429WZS	2022-09-02	Financiamiento ilícito
140	OEJ120920EKR	2024-07-21	Fraude fiscal
141	QUKB821212N9T	2023-01-16	Orden judicial
142	KQE070215H30	2025-05-05	Financiamiento ilícito
143	KOM200421TXH	2024-08-03	Operaciones inusuales
144	JNX980716G29	2024-01-10	Operaciones inusuales
145	PQLG6106034HN	2025-01-09	Fraude fiscal
146	WXJ140611YXT	2022-11-10	Fraude fiscal
147	SFT0604233CD	2022-04-10	Orden judicial
148	XLDV620629RZS	2023-07-22	Fraude fiscal
149	WSHA5104078DZ	2023-11-14	Financiamiento ilícito
150	IDH110323DTV	2026-10-25	Orden judicial
151	WUQE5603268P6	2023-11-04	Operaciones inusuales
152	YYO060712DKT	2026-01-09	Financiamiento ilícito
153	GQP210821HDK	2026-02-27	Financiamiento ilícito
154	SCU010209AT7	2026-02-14	Fraude fiscal
155	FRHP610904RTP	2025-02-08	Financiamiento ilícito
156	QWQD990926CPK	2022-10-23	Orden judicial
157	MOG181026N3O	2024-02-14	Fraude fiscal
158	NNP050417UQO	2022-05-07	Financiamiento ilícito
159	GULK82120189U	2024-07-16	Operaciones inusuales
160	AWOX050621HC3	2025-10-14	Fraude fiscal
161	ISH220621J49	2026-07-15	Operaciones inusuales
162	VBZQ590515QYM	2025-04-17	Orden judicial
163	RJQ260224B9Y	2022-05-22	Operaciones inusuales
164	YCMB52031711E	2025-12-13	Financiamiento ilícito
165	NVHH710828V9R	2022-01-28	Operaciones inusuales
166	HXDL8205178HQ	2025-04-19	Fraude fiscal
167	KZD0304217FL	2023-10-27	Orden judicial
168	VVG190131Q7Z	2021-12-27	Fraude fiscal
169	OZO970128EIH	2024-02-14	Financiamiento ilícito
170	ZNHC710914GIG	2026-07-18	Operaciones inusuales
171	TEDO6401208T6	2026-10-26	Financiamiento ilícito
172	YAJL90060984D	2022-09-11	Operaciones inusuales
173	RCI140116T8V	2023-12-05	Orden judicial
174	ISTW920603BCW	2026-07-20	Orden judicial
175	LSKR830926FQ8	2022-11-25	Financiamiento ilícito
176	YUH240806EYN	2024-06-03	Orden judicial
177	CVCU04052945B	2026-08-31	Operaciones inusuales
178	BYMV890203OCW	2025-04-16	Operaciones inusuales
179	HOAH690329PUX	2025-08-16	Fraude fiscal
180	QWT160405DNT	2022-07-18	Operaciones inusuales
181	KOGS710909A7T	2026-02-01	Fraude fiscal
182	QRSR6704204W6	2023-07-25	Orden judicial
183	GKRC6510219CS	2023-01-16	Fraude fiscal
184	HZQ190528PNM	2025-01-02	Financiamiento ilícito
185	QME1404292GZ	2026-06-06	Operaciones inusuales
186	WDW041115IZ3	2023-04-06	Financiamiento ilícito
187	USC190403FZW	2023-12-01	Fraude fiscal
188	KYW010314RH8	2026-05-28	Orden judicial
189	YXVG970921WTE	2025-06-08	Fraude fiscal
190	VCCT6309183UV	2026-07-21	Financiamiento ilícito
191	OIDJ960901X15	2025-09-03	Fraude fiscal
192	CZDZ600311409	2022-03-09	Financiamiento ilícito
193	HTLN941117L3Q	2021-11-03	Operaciones inusuales
194	WBAX9704075UU	2025-10-13	Financiamiento ilícito
195	KOF260130FJ7	2024-04-16	Financiamiento ilícito
196	ETU260708U1G	2023-04-04	Financiamiento ilícito
197	IIZK890116S9X	2021-11-01	Financiamiento ilícito
198	PRI161106KFX	2022-05-05	Fraude fiscal
199	CLRJ820706F7C	2025-12-07	Operaciones inusuales
200	MFC141014FQJ	2024-02-27	Orden judicial
\.


--
-- TOC entry 3596 (class 0 OID 16848)
-- Dependencies: 225
-- Data for Name: operacion_vulnerable; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.operacion_vulnerable (id_operacion, rfc, id_bien, id_notario, valor_pactado, fecha_operacion) FROM stdin;
1	QRSR6704204W6	150	128	3185941.14	2025-05-15
2	NKE990815LH6	177	126	3661267.63	2026-04-21
3	OAF130120UKW	42	37	2533871.60	2025-06-22
4	ZVY9903102KK	183	118	655632.09	2025-11-23
5	XZK150716R78	132	136	599110.21	2025-12-19
6	KOGS710909A7T	117	122	172710.87	2026-03-26
7	VELK920216YIP	144	95	4609269.80	2026-09-19
8	CLHA5609121WJ	155	105	560577.45	2025-08-24
9	GGLZ880520K6R	147	75	211007.89	2026-01-29
10	HBFB9412217S9	31	96	1531573.72	2025-06-27
11	OVPD740805EL6	78	76	2434768.45	2026-05-24
12	SPVO8207163BB	37	151	2114567.27	2025-09-15
13	LPCS9607124X1	73	56	923554.89	2026-06-07
14	USC190403FZW	126	1	620416.25	2026-09-11
15	JEFY830625RIE	18	12	2093700.02	2026-10-18
16	CCT060715VN8	80	145	2267348.39	2026-05-19
17	WOKD730105WB0	97	122	4173955.34	2026-09-06
18	SCU010209AT7	34	196	701226.21	2025-01-08
19	VHH150425RZD	118	195	2255147.66	2025-01-23
20	SQZ240428TRF	39	187	1632829.27	2026-03-09
21	GIU251019Z0L	171	160	2054045.35	2026-01-18
22	NZOK750603QW9	102	87	2709562.31	2026-06-26
23	YYO060712DKT	114	189	1394101.75	2026-07-12
24	QAHF8905070Y6	43	182	133772.41	2025-07-25
25	SSG171219KIB	198	182	1551151.92	2026-07-25
26	AJC110331VLN	32	165	2801170.59	2025-02-18
27	MOGW600917PHT	159	139	2888509.36	2025-05-27
28	VTRN621210XPN	146	134	955085.41	2026-06-04
29	GBG070115DAN	129	5	610213.05	2025-04-11
30	BNH97071930L	47	5	1382063.01	2026-10-23
31	VIJB030209T64	63	181	4196198.03	2026-06-04
32	OCL150413MRU	114	22	4036535.91	2025-09-05
33	SCU010209AT7	83	103	2948576.20	2026-04-26
34	BAE160608RP2	6	88	2190716.92	2025-06-27
35	WEI120728QJ5	7	136	1593738.35	2024-11-04
36	QCLL86010685J	24	30	4899132.71	2025-03-10
37	OVV051108PT5	44	74	728730.92	2026-07-27
38	BHQO620813L9T	197	23	779594.58	2025-11-16
39	QHI020205SH3	174	44	303979.54	2024-11-01
40	ECLL840110Q0Y	47	7	3569370.11	2025-01-14
41	ZWAS511001YTJ	100	26	1607006.90	2024-12-24
42	GVK2404226L1	83	67	1883810.66	2026-06-23
43	CZDZ600311409	14	52	1205718.59	2026-04-24
44	XSI220713E6K	151	61	2469967.41	2025-09-20
45	SYX130101G5G	130	99	4747291.71	2025-12-12
46	WLRQ721003VA2	16	82	2329469.43	2025-09-19
47	QHI020205SH3	17	124	154243.12	2026-03-23
48	NFL040208HJ3	60	5	1353107.09	2025-06-11
49	RSU210810C9R	173	26	1239117.32	2026-05-23
50	XQP070107AJ2	167	33	1530018.08	2025-09-30
51	QHI020205SH3	115	22	4232926.48	2025-03-12
52	IHV120205E4X	53	37	1872793.05	2025-03-17
53	QOFP4707153A3	63	138	4763537.01	2025-08-18
54	XQP070107AJ2	116	11	14995.28	2025-03-24
55	IQX190413DUT	159	75	3268763.66	2026-04-30
56	NXJS56032633I	1	16	4668199.01	2025-02-12
57	QEY020608JXJ	70	154	1261935.90	2025-04-02
58	NKK090528FV1	98	90	4213768.98	2025-11-12
59	KOGS710909A7T	150	131	1413743.33	2025-03-21
60	UWXF681226ID2	190	137	2819777.07	2025-11-25
61	GCLS520223LVS	23	102	3495162.26	2025-01-24
62	QWQD990926CPK	186	143	4994118.05	2025-10-16
63	REZ010808IGF	54	157	2529053.05	2026-01-14
64	ATUC950629PG8	175	88	3179497.70	2026-07-25
65	SYX130101G5G	182	116	1372335.56	2025-04-14
66	TEZ26102083E	83	88	1061013.23	2025-03-24
67	TIC110701ALM	85	5	4570951.02	2025-04-05
68	VWAT560531L72	166	1	3047845.88	2024-12-15
69	DWLX660221QDY	3	173	875944.74	2026-06-05
70	XQP070107AJ2	179	181	2449993.81	2025-03-21
71	LAP030128HVN	138	21	3938653.12	2026-07-21
72	FFB000103MKT	167	20	2697860.15	2026-06-12
73	YYO060712DKT	114	173	625843.80	2025-03-29
74	AYVQ6312282EK	154	92	1939887.66	2025-05-20
75	MPM1312101H6	179	3	632571.69	2026-10-01
76	GGLZ880520K6R	50	114	56722.88	2026-09-08
77	HBF0302262VF	6	195	1412861.07	2025-09-13
78	PKD080128LN4	92	50	458932.93	2025-10-08
79	PFD210901F0V	161	78	4043988.33	2026-03-01
80	ISHY8704153TQ	60	127	4836809.57	2026-10-10
81	SIEY960418MDD	72	127	4523492.87	2026-02-28
82	JGC981127U0I	156	54	45605.65	2025-01-23
83	NNP050417UQO	102	29	4350882.00	2026-09-05
84	KOF260130FJ7	129	127	860680.71	2026-03-09
85	MSQV460120C1Q	169	190	2832878.17	2025-03-09
86	IGT25031476A	155	145	885888.91	2024-12-31
87	SJZ140210DDE	33	191	334596.11	2025-06-15
88	GVOS890614SEK	146	59	4406205.43	2025-01-05
89	HVN141030WEB	71	50	4239859.22	2025-08-20
90	ISTW920603BCW	178	174	2669378.17	2025-02-04
91	HOAH690329PUX	175	144	4416678.66	2025-06-02
92	YAJL90060984D	110	165	3368767.93	2024-12-19
93	FFB000103MKT	14	83	2168415.38	2025-07-23
94	QHI020205SH3	71	32	3404065.64	2024-11-23
95	BCU100623QE4	127	93	2591112.00	2026-01-28
96	PGWE860804LUL	185	58	244353.59	2025-05-01
97	YLR000217XDW	137	115	1588047.40	2025-11-06
98	DYW070703T60	50	86	418226.42	2025-11-11
99	CMW070804XYF	7	189	1135883.74	2026-04-06
100	KNX080517YT2	109	20	4585806.16	2026-06-13
101	GKRC6510219CS	43	85	1560921.23	2025-01-17
102	IGD170128FY3	161	25	149085.03	2024-11-07
103	REZ010808IGF	7	152	3988132.32	2024-12-17
104	KQFS481015RIX	65	64	548124.86	2025-05-25
105	RVUF521022BLJ	88	14	4109952.64	2026-06-06
106	KZD0304217FL	61	19	3880989.86	2024-11-05
107	OCC98072113N	113	196	487397.04	2026-03-31
108	VVG190131Q7Z	149	32	436818.15	2026-01-26
109	WIDX080126A4F	9	97	1573264.38	2026-07-05
110	TRM020628UJO	17	33	319391.15	2024-12-02
111	GXX261001CNO	15	78	3057585.81	2025-01-14
112	REZ010808IGF	17	27	3391046.64	2025-04-12
113	LPI04032800E	14	76	4251147.27	2025-12-10
114	YYK10041998B	25	159	3762297.15	2026-07-07
115	NZOK750603QW9	154	169	3123800.70	2024-11-05
116	VWZ190929EL8	99	119	3977871.74	2025-08-18
117	OCC98072113N	159	26	1704686.21	2026-02-11
118	CGF050914SA7	7	117	2590892.33	2025-12-08
119	RSU210810C9R	50	28	522421.37	2026-06-14
120	TPB181211MC9	183	18	2968503.63	2025-05-25
121	MSQV460120C1Q	147	33	3190445.04	2026-10-25
122	QCLL86010685J	91	108	2412182.52	2025-11-12
123	OCC98072113N	114	48	1223330.86	2025-11-02
124	PGWE860804LUL	16	33	1565217.62	2026-06-10
125	VQV260802ZKW	132	167	3774324.44	2025-07-19
126	FIWZ680927KXO	150	139	3879723.37	2026-02-12
127	CRHS860520X65	121	80	3020614.15	2025-09-29
128	DGER890731AA2	95	3	2593226.14	2025-07-19
129	KLT260226IQ2	174	38	296015.05	2025-08-14
130	OWC121130TBH	144	14	2116085.09	2026-04-13
131	GKRC6510219CS	52	164	4543416.09	2026-09-22
132	WMWO760908QPG	88	49	3342622.09	2025-07-24
133	TRM020628UJO	178	120	3002813.89	2025-07-02
134	VXCV040606IVS	149	145	4815693.80	2026-07-27
135	PEH051113YE0	77	108	1649809.06	2025-05-05
136	YCAI050801FYO	117	11	2484694.06	2026-10-31
137	YAJL90060984D	164	58	3469170.58	2025-08-07
138	BCU100623QE4	160	55	1202705.01	2026-03-31
139	ILB260220MAE	197	85	4038283.82	2025-09-05
140	AYVQ6312282EK	53	103	929380.12	2025-08-20
141	DNOU980212GC5	93	3	377918.47	2026-02-17
142	MLHT550401EPK	143	30	720585.85	2024-12-14
143	NKE990815LH6	50	162	2932575.10	2025-08-03
144	XEC120604HGZ	93	12	4876793.28	2026-09-09
145	RRPV8406067DI	51	73	878991.58	2025-07-14
146	ZVOY9205079YJ	185	45	1705689.29	2026-07-19
147	FDS03101374L	63	46	987977.92	2025-01-16
148	WPUS640719T9N	68	26	114758.86	2024-11-02
149	SBD150308LOS	36	98	3277797.29	2025-10-20
150	CXDL670401Y08	87	54	1532311.17	2026-09-07
151	RVUF521022BLJ	95	96	3307934.49	2026-04-26
152	BMU1909080O3	160	112	4393155.30	2025-09-08
153	FCVJ7412271U3	31	37	4414788.38	2026-05-17
154	NIPE00092590K	49	50	2667448.01	2026-08-10
155	TRM020628UJO	96	82	3001750.32	2026-09-20
156	VHH150425RZD	63	12	3817781.05	2026-10-19
157	RSU210810C9R	49	138	1477971.90	2025-02-15
158	JJFG5505017XV	84	64	275762.29	2024-11-19
159	FFLA020410MYO	33	131	4842237.69	2026-02-10
160	DTG1909089G5	54	187	416224.43	2025-02-03
161	ABX001128PE6	170	158	333716.47	2026-09-05
162	RQM130507RAT	100	193	4413286.21	2025-12-17
163	EZW070806RLR	131	96	2497953.00	2025-06-05
164	IQX190413DUT	46	83	3565309.50	2026-04-27
165	BMU1909080O3	178	124	3581092.86	2026-06-06
166	ZDN230719AXP	122	69	2910121.56	2026-07-26
167	NNP050417UQO	150	167	192656.39	2025-05-12
168	RHOR4801070BV	52	116	4317209.64	2025-08-13
169	IJU990930ZXY	56	79	2130864.04	2025-10-17
170	ZNYC5210158G8	147	41	4678139.55	2026-02-23
171	OVPD740805EL6	66	141	432946.99	2026-04-16
172	EZW070806RLR	22	76	2228081.52	2026-03-26
173	KUIY0508181HS	59	150	215303.18	2026-09-06
174	KOM200421TXH	160	87	2136250.69	2025-11-04
175	PRI161106KFX	111	105	1843884.59	2025-12-04
176	YIQ9809042LM	82	70	1918030.92	2025-09-16
177	BDDE710412LZM	114	60	1335468.14	2026-03-27
178	ZNHC710914GIG	92	22	1479643.93	2025-03-25
179	IHV120205E4X	132	140	3221835.45	2024-11-02
180	YWWJ041227F4Z	59	26	601753.53	2026-03-10
181	PGEO950614TD9	10	140	1009529.92	2026-07-24
182	GKRC6510219CS	173	85	1257617.98	2025-07-08
183	DEY07071028X	197	175	4228786.69	2024-11-12
184	NBDI020606RQV	181	155	4989998.57	2026-03-07
185	SYX130101G5G	184	190	2720196.92	2025-08-06
186	XLDV620629RZS	3	198	1504376.02	2026-09-09
187	IIZK890116S9X	104	104	4111087.97	2024-12-05
188	GMR0005103OD	168	4	2365299.93	2026-07-20
189	KOM200421TXH	195	39	4328675.94	2026-05-25
190	JABN961206I9N	59	186	3748194.01	2025-07-10
191	VVE160124V3Z	60	133	2939148.16	2026-04-10
192	IHL05022152W	194	120	3615326.65	2025-10-11
193	TZQ110927P9N	88	22	1572243.42	2025-04-30
194	HNNE5610297FX	110	198	4710229.59	2026-02-14
195	OAF130120UKW	54	113	2255359.96	2025-11-11
196	MWH040428Z36	8	96	703361.63	2025-09-06
197	LJNI48121343D	79	189	58308.96	2026-05-28
198	EZS04121472I	91	87	1135198.29	2026-02-18
199	TGA251105OIM	176	193	2022809.90	2026-07-09
200	MXO041205XCB	177	138	1505189.67	2025-01-02
\.


--
-- TOC entry 3589 (class 0 OID 16784)
-- Dependencies: 218
-- Data for Name: persona_fisica; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persona_fisica (rfc, curp, nombre, ingresos) FROM stdin;
PQKP851207S7H	PQKP851207MSPSBF56	Sra. Elvira Trujillo	62411.14
YAJL90060984D	YAJL900609HHGDWGT3	Dr. Alvaro Escalante	361226.08
DWLX660221QDY	DWLX660221HTCBRS47	Andrés Jos Arce Colunga	234120.06
DNOU980212GC5	DNOU980212HZSBTPF9	Samuel Zavala Lugo	246636.66
ESOG0810211B0	ESOG081021HGRTDLL5	Araceli Arroyo Cardona	257013.96
CPVO791125LCX	CPVO791125MTCZYV95	Conchita Citlali Linares	485540.91
EMDQ880811AOU	EMDQ880811MDFDQXI8	Lic. Olga Valenzuela	431746.70
BKOK510313HP6	BKOK510313HHGGTSX2	Mauro Santiago Murillo Aranda	490854.39
DNTE520915HR0	DNTE520915HPLSTPK6	Isaac Javier Negrete	340379.31
PCIZ870411ZS1	PCIZ870411MTSVNB50	Andrea Lourdes Urbina	107952.18
LSKR830926FQ8	LSKR830926HNLSFCS3	Humberto Modesto Cervantes	379261.03
ISTW920603BCW	ISTW920603HQRWDXQ3	Hernán Jesús Soto	373782.24
HFDG790602LA0	HFDG790602MMNNVSO0	Mitzy Diana Fuentes	463977.56
EGLL720107SFN	EGLL720107MTCZZJJ0	Sra. Barbara Vázquez	374398.28
MUNC550723S8B	MUNC550723HTLWYSN9	Araceli Roybal	277841.42
MLHT550401EPK	MLHT550401HHGJFS62	Dra. Lourdes Mateo	370188.95
ZMMY631004S20	ZMMY631004HSLBHH54	Ing. Cristobal Valladares	12766.12
RYJT530127UTO	RYJT530127MDGBYQR9	Miriam Ruby Salinas Salcedo	423138.59
SIEY960418MDD	SIEY960418MZSVPCP8	Vicente Gabriel López Esquibel	117781.39
BDOH0208059E1	BDOH020805HCLVFPE5	Clemente Alva Rivero	118387.06
GDOB0601131HH	GDOB060113HQTJJYM7	Fernando Víctor Pedroza	498349.23
HTLN941117L3Q	HTLN941117HCHSMXM9	Amanda Hilda Montez	129475.31
PGWE860804LUL	PGWE860804HPLLVD94	Sandra Galindo	22105.81
BWWP740724SQT	BWWP740724MTLNJRB1	Felipe Lerma Hernández	474623.79
ITDJ460813F31	ITDJ460813HASRGR76	Iván Isaac Santillán	419475.89
YXVG970921WTE	YXVG970921HTSRYT57	Guillermina Aguayo	361265.46
KFZN060719DBD	KFZN060719HCMCFH23	Joaquín Jorge Ortiz	456383.42
VTRN621210XPN	VTRN621210MSLMLJE1	Lic. Alicia del Río	272068.84
JAWE650711H2M	JAWE650711HBSSCY34	Jesús Mireles	307217.26
BTMQ8912076GV	BTMQ891207MTLLWB53	María José Alta  Gracia Chacón Rosario	76826.92
SVKR89052139R	SVKR890521MNLZFSW5	Zeferino Maximiliano Terán Meza	479121.91
WIDX080126A4F	WIDX080126HDGDBQJ1	Lilia Ana Luisa Soliz Luna	159298.66
ZHQP56112508H	ZHQP561125MJCLRN53	Dra. Noelia Tello	312273.61
FCVJ7412271U3	FCVJ741227MHGDSP18	Fernando Vélez Meraz	236019.95
RMNW470228P50	RMNW470228HNLSHGK5	Anabel Córdova León	184997.80
WMWO760908QPG	WMWO760908HCSHCGH5	Jonás Núñez Téllez	312007.79
CKAF530530SAH	CKAF530530MDGPKJF0	Salvador Uriel Ordóñez Escobar	163475.24
ITJT0602023JC	ITJT060202HTSHKSB7	Sra. Georgina Mascareñas	236795.70
ZNHC710914GIG	ZNHC710914MOCNDR24	Héctor Pedraza Briseño	430769.69
VGES850717LMA	VGES850717HHGHXC20	Elsa Jaqueline Razo Madrid	426297.76
NZFJ790131BR5	NZFJ790131HSRVGB98	Ramón Madrid	241330.94
HKIP7110212XC	HKIP711021HSPLXQU2	César José Manuél Archuleta Ferrer	237703.56
XHKD9409088KR	XHKD940908HSRKBHY9	Martín Patricio Alvarado	345239.21
JZHZ5712288CW	JZHZ571228HTLFPPV2	Martha Cecilia Espinal Molina	370600.71
PQLG6106034HN	PQLG610603MQRBTG93	Mitzy Gloria Menchaca Collazo	30976.14
QAHF8905070Y6	QAHF890507HSPLYX15	Rafaél Cristobal Flórez	60580.26
TWYK6510130TV	TWYK651013MMSQPKD9	Maximiliano Ontiveros Solorio	330134.91
LKHG9407237P5	LKHG940723HMSKYNC5	Abelardo Jacinto Armendáriz	248562.17
VJYZ530818QKN	VJYZ530818MASNDF24	Sra. Hilda Robles	113643.38
MCBL930804LJD	MCBL930804HGTKTD85	Camilo Soliz Marrero	362925.27
UWNL6311108CR	UWNL631110MYNNQRE3	Samuel Marrero Fuentes	31140.72
WVGU600626D54	WVGU600626HDFRBQ24	Débora Espinoza Llamas	461998.97
ANPW9208305PS	ANPW920830MBCXTWY3	Ing. Mario Carvajal	230109.65
YCAI050801FYO	YCAI050801MYNFWQS2	Dr. Eloy Lara	315373.75
WVCW980610IQV	WVCW980610MGTTKML3	Adalberto Zacarías Valencia	195323.56
WUQE5603268P6	WUQE560326HCSBNYO2	Aurora Fonseca	306700.40
CXDL670401Y08	CXDL670401HYNXQXJ1	Irene Ulloa	55663.08
DFPT880713XG1	DFPT880713HASXVRI5	Estela Cisneros Limón	438663.91
RZPU6202160YA	RZPU620216MMCYNVC9	Srita. Claudia Batista	57881.29
OHDR640101Z7S	OHDR640101HMSNGXA8	Ing. Reynaldo Quiroz	210236.89
CLHA5609121WJ	CLHA560912HASSVQ40	Cristobal Anaya Rodríguez	193764.64
CZDZ600311409	CZDZ600311HPLLDLL4	Carlos Olivera Ayala	428938.69
PZRA4604113KX	PZRA460411MSPQZL78	Marco Antonio Julio César Duarte	394056.32
VBZQ590515QYM	VBZQ590515MGRKPHB5	Lic. Ruby Ramírez	389355.30
VGVM50050430M	VGVM500504MDFWRTG2	Dra. Gloria Mercado	59136.52
LJNI48121343D	LJNI481213MQTVQS16	Renato Berríos	482639.42
NIPE00092590K	NIPE000925HCMWMQ34	Ofelia Caridad Cabán Rocha	118667.42
IWSH700406LOO	IWSH700406HBSTYLN4	Mauro Jacinto Rivero	358686.86
VWAT560531L72	VWAT560531HGRRMGN8	Eloisa Elena Colón Holguín	150143.19
IMGG451115DKN	IMGG451115HMCQSKN2	Karina Elizondo Menéndez	52552.98
SKCA490115L2W	SKCA490115MSRKLQI1	María Saavedra Anguiano	460396.94
QWQD990926CPK	QWQD990926MQRKWGY7	Nicolás César Montoya	465559.78
WOCV0601164K1	WOCV060116HMSFNPI5	María del Carmen Claudia Leyva Montero	474037.58
SPVO8207163BB	SPVO820716MMSSZPR5	Lic. Camila Sauceda	481006.98
EQQV620323FYB	EQQV620323MVZXXN96	Lorenzo Carlos Melgar	320494.28
CRHS860520X65	CRHS860520HMCVLKJ4	Silvia Batista	131646.23
JJFG5505017XV	JJFG550501HSRSWCX7	Lic. Leonel Villanueva	163797.66
CVZC581202ALY	CVZC581202HNTFTY63	Elvia Rosa Guerrero	125082.07
HBFB9412217S9	HBFB941221HMSGGHM2	Celia Rosario	391679.86
AYWV471111LC5	AYWV471111HCMSRQR8	Anabel Indira Frías	479416.61
VELK920216YIP	VELK920216MSPRNZW4	Ing. Luisa Valverde	250494.62
NTHZ700714YE9	NTHZ700714MSRGQCS7	Natividad Gracia Delgadillo	470430.67
UWXF681226ID2	UWXF681226HQRLSFZ8	Salvador Omar Carrero	235434.59
YCMB52031711E	YCMB520317HASSKDD4	Lic. María del Carmen Melgar	101704.70
HVNM610505P0J	HVNM610505MMNHZK66	Ariadna Rael	113160.92
NXJS56032633I	NXJS560326MSPWHF49	Iván Lorenzo Barrios Zamora	346145.84
QOFP4707153A3	QOFP470715HNTVPW72	Teodoro Juan Menchaca	241763.64
FKIJ700620Z1U	FKIJ700620HGRLDXM8	Sessa Soledad Ballesteros Bustamante	363074.56
IPDJ7709078ZO	IPDJ770907MOCHXC32	Darío Vera	39417.83
HBKU681225QD6	HBKU681225MYNWDT95	Diego Córdova Regalado	284571.52
WPUS640719T9N	WPUS640719MQRBDXY3	Florencia Orellana	292658.34
BDDE710412LZM	BDDE710412HNLKSNQ1	Lic. Marcela Estévez	196724.79
PUFN700829QP4	PUFN700829MVZRFFT5	Jaime Luna	216690.08
FREE710109CAQ	FREE710109MCLCKJN4	Dra. Luisa Montañez	306638.64
ABUJ071209NUV	ABUJ071209MNTXVYQ8	Serafín Abraham Segovia	483107.76
HBNI920221QC3	HBNI920221MGTFBTN1	Camila Francisca Bañuelos	113180.03
HNNE5610297FX	HNNE561029MCSDYM16	Nayeli Avilés Abrego	266751.57
NBDI020606RQV	NBDI020606HCSHFRV4	Isabel Carmona	122384.42
MOGW600917PHT	MOGW600917MTLRDW15	Sr. Genaro Preciado	431580.72
MSQV460120C1Q	MSQV460120MYNMXYJ2	Ing. Rosario Matías	485075.71
GKRC6510219CS	GKRC651021HVZRRPI8	Leonor Juana Puga	161734.05
RRPV8406067DI	RRPV840606MYNPVMD4	Dolores Delgadillo	86301.59
KTEK600420DRO	KTEK600420HASNTDA8	Carlota Cynthia Vaca Olivo	14075.38
QILP7302180DK	QILP730218MYNJVVL0	Liliana Corrales Lomeli	278623.98
CLRJ820706F7C	CLRJ820706HTCXMHP6	Daniel Abraham Becerra Alemán	415929.16
VIJB030209T64	VIJB030209HMSCRNS9	Omar Mariano Chacón Bravo	405711.72
BPNW601101F8C	BPNW601101MNLRPH61	Luis Manuel Mauro Zayas Pizarro	99379.52
AQDM871204BNH	AQDM871204MCHRQHM3	Srita. María Saucedo	167115.42
KOGS710909A7T	KOGS710909HCCZBZA2	Nelly Margarita Olivo	360446.01
GULK82120189U	GULK821201HMCCBGF7	Elena Escamilla Pineda	499002.09
SFQG000901R64	SFQG000901MBSJWY26	Sra. Olivia Samaniego	44978.50
NVHH710828V9R	NVHH710828MGRGWWT1	Pascual Jiménez	487553.27
RHOR4801070BV	RHOR480107HSLVMT17	Natividad Olivia Navarro	370308.16
ISHY8704153TQ	ISHY870415HJCMSJB0	Alfonso Vanegas Rosas	374915.04
LGGO960327JV6	LGGO960327HMSNJK13	Beatriz Vera Rosario	486904.29
VCCT6309183UV	VCCT630918HTSJFH43	David Ramón Lemus	14375.63
JABN961206I9N	JABN961206HYNSFV87	Minerva Angélica Solorzano Bueno	54786.76
PANG530604FPW	PANG530604MCCCRSS2	Modesto Bernal	249043.01
FRHP610904RTP	FRHP610904MQRVMGO5	Pamela Marrero	364955.59
NZOK750603QW9	NZOK750603MBSNMJP3	Sra. Indira Téllez	287683.85
TJKO530612HTC	TJKO530612MPLTHWW8	Modesto Rendón Sepúlveda	88568.27
FVLH9710152IA	FVLH971015HTLJHK08	Olga Hermelinda Pérez Morales	195731.35
RVUF521022BLJ	RVUF521022HBCRKRB1	Ing. Emilio Aranda	332561.81
BBLM811204HVL	BBLM811204MHGPNPM5	Dra. Norma Hurtado	210804.22
WKQE640928759	WKQE640928MCHDRBX2	Nicolás Véliz de la O	438011.46
WSHA5104078DZ	WSHA510407HCSNDPU7	Sra. Sofía Lovato	267652.47
OIDJ960901X15	OIDJ960901MCCKQCX3	Sra. Fabiola Rubio	331317.19
CNQI63110131Y	CNQI631101HVZVCPX6	Cristian Patricio Bermúdez	412792.99
ESEJ9512149XU	ESEJ951214HNTPTW23	Ing. Cristobal León	480687.51
HOAH690329PUX	HOAH690329HCSTPFI3	Ing. Adalberto Carrasco	289313.56
BHQO620813L9T	BHQO620813HTCTVQO6	Srita. Paulina Corona	442583.77
QCLL86010685J	QCLL860106HGRPNRJ9	Ivonne Concepción Ibarra Gracia	227075.96
GVOS890614SEK	GVOS890614MPLPZWE6	Cristal Mónica Apodaca Montalvo	414815.94
XLDV620629RZS	XLDV620629MMNPGVX4	Diego Teodoro Corrales	186404.19
ZVOY9205079YJ	ZVOY920507MTLZBBA0	Lilia Judith Granados Quiñónez	263628.59
QRSR6704204W6	QRSR670420MASJGW04	Fernando Samuel Montaño Ayala	460364.92
QOQT981026OXR	QOQT981026HCSBKDD9	Sr. Amador de la Fuente	132429.88
WLRQ721003VA2	WLRQ721003MOCCLYQ5	Laura María José Madera Rolón	398523.06
FYWI911119XO6	FYWI911119HZSWSQW9	Eloisa Ojeda	324704.77
QFXW861020CIY	QFXW861020HSLCCVC6	María José Estefanía Colunga	214095.64
SGKR641006KL1	SGKR641006HMCTWYM6	Luisa Alcala	36522.69
YWWJ041227F4Z	YWWJ041227HPLPFN70	Lic. Juan Mata	340081.27
WBAX9704075UU	WBAX970407MTLTQCF6	Trinidad Arguello	82526.08
FFLA020410MYO	FFLA020410MCMMTP96	Renato José Preciado	255893.33
TISH041018JEG	TISH041018HDFNGLK8	Dra. Hilda Jimínez	311838.45
GAUI5608060W1	GAUI560806HMNCVJX1	Sr. Gonzalo Viera	65139.64
TEDO6401208T6	TEDO640120MTSKGKN4	María del Carmen Tania Guardado	92935.08
STWZ080503ENU	STWZ080503MTLRMY85	Srita. Miriam Miranda	86435.70
HXDL8205178HQ	HXDL820517HCHTHR54	Jacobo Roberto Alarcón Aguilera	16729.31
DGER890731AA2	DGER890731HOCMBGJ3	Adalberto Luis Calvillo	277747.86
FHCG610108DKW	FHCG610108MYNRZSO6	Aurora Ramírez	295672.42
QUKB821212N9T	QUKB821212HMSFHVM0	Dulce María Limón Heredia	237830.80
ZWAS511001YTJ	ZWAS511001HCLLHWN1	Alejandro Alva	19348.38
GCLS520223LVS	GCLS520223MMCZNSW7	Sra. Ana Luisa Villegas	434718.65
MGOO0110049K9	MGOO011004HGRGZPP0	Timoteo Casas	131222.15
EPRG760527E6I	EPRG760527MQTNTBO5	Benjamín Tomás Cedillo	316363.18
LPCS9607124X1	LPCS960712HNTWRXW0	Sofía Sessa Valles	472626.98
DBCX500226MZS	DBCX500226MMCFXR36	César Esteban Hernandes Lozano	265151.74
AUXR490822FPM	AUXR490822HTCHFZW5	Soledad Ángela Rendón Lebrón	230092.90
FIWZ680927KXO	FIWZ680927HJCRQS72	Verónica Sonia Mejía	161409.21
TYFA700611FEY	TYFA700611HTSZZFX2	Dr. Arturo Lebrón	165573.14
MTTL5609207UW	MTTL560920HGRJXTR6	Juan Oquendo Mercado	480986.13
ATUC950629PG8	ATUC950629MTLTWRQ2	Gregorio Jaimes Domínguez	391762.86
MXHU000813VMW	MXHU000813HDFFVQ99	Andrea Marisela Fernández Orozco	310057.39
HDKY030704Y6W	HDKY030704HMCSKSH8	Óscar Carlos Colón Toledo	424607.74
LSXB0303112KN	LSXB030311MSPFLM53	Dulce Rocío Caraballo	25792.48
ECLL840110Q0Y	ECLL840110HNTYGS73	Yolanda Esperanza Candelaria Aragón	42406.80
OFST850214GV0	OFST850214MZSSXXF0	Arturo Salvador Henríquez	307885.68
SZPJ850812UHX	SZPJ850812MPLLYQJ0	Aida Marisol Córdova Abrego	265118.05
VXCV040606IVS	VXCV040606MVZWBZI6	Julio Jáquez Coronado	492077.02
DUAO800519N2T	DUAO800519HSLNRCA6	Karina Velasco Acosta	443354.81
KQFS481015RIX	KQFS481015MVZFJYO2	Wendolin Salas	237153.69
WOKD730105WB0	WOKD730105MCMTDVX8	Luisa Leonor Barrios Toledo	76300.27
YQVS901031P08	YQVS901031MPLMFQP3	Abel Olivo	442448.74
SYQU890425SEH	SYQU890425HMSJRS51	Blanca Ofelia Tello Muñoz	54683.71
ZPYX820429WZS	ZPYX820429MSPCSTZ9	Trinidad Madrigal Pacheco	475379.41
OGTE050608M25	OGTE050608MSLBFKV2	Bernabé Navarrete Téllez	89440.81
IIZK890116S9X	IIZK890116HGRVCJQ7	Angélica Rico Longoria	151502.46
JEFY830625RIE	JEFY830625HCHXZBR0	Ernesto Urrutia	234734.90
QGCT050126RNU	QGCT050126MASQNGN7	Juan Carlos Espino Luna	210974.17
KUIY0508181HS	KUIY050818HASHPRK3	Barbara Ruby Muñoz	33970.21
UWPD50072692M	UWPD500726HCCRBWO9	Antonia Ruby Quezada Espinal	156236.36
QXVB910610FL0	QXVB910610HCCDZFA9	Alfonso Evelio Alvarado Villaseñor	290418.47
DOIO640315TQL	DOIO640315HVZTKBR5	Óscar Ordóñez	190599.02
PGEO950614TD9	PGEO950614MCLTWCG1	Reynaldo Iván Sanabria	350363.52
TMNM671122LA8	TMNM671122MQTPPSM1	Margarita Alemán	289969.87
HVZG561214TN7	HVZG561214HYNTQVP6	Jonás Badillo Miranda	308333.86
CVCU04052945B	CVCU040529MMSPZK49	Lorenzo Casanova Galarza	253234.49
AWOX050621HC3	AWOX050621MZSVXGA3	María Cristina Terán	10774.65
GGLZ880520K6R	GGLZ880520HVZRDWS6	Santiago Gabriel Becerra Arce	212880.16
NZVU920323EJX	NZVU920323MQRPRB74	Óscar Adán Rodríguez Armenta	134664.59
OVPD740805EL6	OVPD740805HOCJPV45	Cristobal Alcaraz	177267.18
AYVQ6312282EK	AYVQ631228HGRGWYH7	Alvaro Iván Calderón Reyes	400654.65
ZNYC5210158G8	ZNYC521015HYNFMXW7	Srita. Paulina Barela	394154.63
DFIP800322IHC	DFIP800322MCCWJTB8	Claudio Pablo Yáñez	19172.03
TOLA930505C56	TOLA930505MQRCFWC6	Srita. Anabel Fierro	316990.32
BYMV890203OCW	BYMV890203HSLFDVB5	Ilse Teresa Padilla	357821.61
ISQW60101144N	ISQW601011MTCCXKT4	Bianca Velásquez Trejo	115908.54
IVNS661005K3N	IVNS661005MGRDVVW7	Javier Fidel Armenta Villaseñor	257937.40
FDYO470822R23	FDYO470822MDGFYTI5	Joaquín Antonio Casárez Lara	80214.57
\.


--
-- TOC entry 3590 (class 0 OID 16796)
-- Dependencies: 219
-- Data for Name: persona_moral; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persona_moral (rfc, representante_legal, razon_social, fecha_constitucion) FROM stdin;
DYW070703T60	Luis Manuel Enrique Negrón Uribe	Club Guerrero-Verdugo	1979-08-09
LAP030128HVN	Bruno Vicente Ocampo Cotto	Ruiz A.C.	1977-04-07
IJU990930ZXY	Ernesto Burgos Villaseñor	Club Rolón Castro y Fonseca	1986-07-28
HHF130514ZLM	Lic. Luis Griego	Industrias Archuleta-Ybarra	1989-01-30
WDW041115IZ3	Reina Araceli Madera Montero	Acuña Valdez y Gracia	1989-11-22
YYK10041998B	Raúl Bernardo Nájera	Club Frías y Lebrón	1980-06-12
HZO051107R74	César Córdova	Salinas y del Valle S.A.	2022-06-09
QME1404292GZ	Amador Narváez Linares	Club Heredia y Mesa	2018-10-23
QHI020205SH3	Amanda Aurora Ávila Terrazas	Grupo Anaya-Rubio	2011-11-16
CVI990429ORX	Arturo Genaro Rael	Perea-Farías e Hijos	2022-11-23
APX190815144	Elisa Carmona Melgar	Despacho Granado y Paz	1990-06-10
GVK2404226L1	Dulce María Anel Rodríguez	Ayala y Pulido S.A.	1991-07-18
WEI120728QJ5	Ing. Conchita Ontiveros	Chacón-Reyna e Hijos	1990-01-17
OAF130120UKW	Estela Fierro Meza	Despacho Varela-Balderas	1995-12-06
HKC101027669	César Miguel Ángel Reynoso Peralta	Proyectos Montalvo-Garay	1996-12-02
YLR000217XDW	Srita. Sandra de la Rosa	Despacho Patiño y Solorio	2010-02-15
VBO990723P8I	Silvano Rojas	Leiva y Alcaraz e Hijos	2005-12-19
TGA251105OIM	Gerónimo Menchaca	Venegas Garibay y Villareal	1986-12-21
HCB0105269X5	Sra. Liliana Armendáriz	Rodrígez e Hijos	2011-02-23
SFT0604233CD	Manuel Tamez Orta	Calvillo y Regalado S.C.	1993-03-14
IDH110323DTV	Rodrigo Adalberto Palomo	Grupo Muñoz y Lucero	1993-02-06
REZ010808IGF	Adán Octavio Magaña	Laboratorios Rico-Vásquez	2016-07-20
BTK080502IH5	Mauro Rivas Chavarría	Escalante Nevárez y Rivera	2024-09-25
VQV260802ZKW	Zeferino Batista Olmos	Tamez-Apodaca S.A. de C.V.	2005-10-25
QNK130523ZCT	Dr. Aurelio Meza	Serrato e Hijos	2001-08-09
NKE990815LH6	César Olivera Navarrete	Arevalo y Navarrete S.A. de C.V.	1988-10-05
GXX261001CNO	Virginia Barrera	Grupo Mesa y Griego	2013-07-22
VMC150723B1K	Octavio Santiago Fuentes	Corporacin Morales y Jaramillo	2011-02-07
VVG190131Q7Z	Esther Ana Barajas	Montaño-Regalado S.C.	2010-12-16
SQZ240428TRF	Blanca Rodrígez	Club Nazario Barraza y Escobedo	2007-12-29
SBV990222LDI	Aurelio Julio César Duarte	Despacho Cardona de Anda y Leal	1984-06-16
CZM97112546N	Pablo Eduardo Flores Soliz	Lozada S.C.	2023-04-10
VWZ190929EL8	Caridad Rojo	Peres-Quiroz e Hijos	2020-09-14
JXN240127WD1	Humberto Esparza Barajas	Gómez y Asociados	2012-03-12
YMS981123PKY	Lilia Véliz Montalvo	Ruelas-Villaseñor e Hijos	2024-04-03
LQW100829DSK	Nayeli Rael	Maestas y Valverde S.A.	1997-09-09
TZQ110927P9N	Gregorio Gabino Roybal Nieto	Proyectos Arreola Cordero y Morales	1996-03-09
IQX190413DUT	Clara Rosa Cruz Tello	Grupo del Río Corrales y Cuellar	1993-01-09
BCU100623QE4	Alfredo Jaime Velasco	Club Hurtado-Negrón	1989-05-22
PRI161106KFX	Rolando Aragón	Montañez-Cordero S.A. de C.V.	2007-05-08
ABX001128PE6	Citlali Tejeda	Despacho Alvarado Palacios y Sanabria	1986-09-23
ZSC98100776S	Guadalupe Cecilia Acuña Treviño	Lucero-Rojo S.A. de C.V.	2015-11-17
VVE160124V3Z	Rubén Martín Mireles Carreón	Arevalo y Chávez e Hijos	2014-04-30
GBG070115DAN	Iván Alberto Padilla	Club Munguía y Caballero	1999-01-16
ANH0402149A3	Uriel Esquivel Vergara	Proyectos Ledesma y Estévez	1978-05-15
DZS100906S9B	René Mateo Brito	Esquivel Salas y Matías	2017-11-17
QEY020608JXJ	Lic. Ana Luisa Muro	Cordero Ponce y Negrón	2003-02-09
UBZ110204T19	Adriana Linares Montaño	Manzanares-Ramírez y Asociados	2015-01-05
ZVY9903102KK	Flavio Martín Pelayo	Lomeli y Dávila y Asociados	2026-05-17
BLK260323RCJ	Liliana Carlota Villagómez	Colón-Franco	1997-06-20
DTG1909089G5	Mitzy Hilda Barraza Villanueva	Bueno Aguayo y Parra	2020-04-21
BAE160608RP2	Lic. Eric Valadez	Vanegas y Chapa S.A.	1989-06-29
SOM1804225L8	Florencia Nelly Salas	Madrid y Asociados	2016-08-28
ZDN230719AXP	Lic. Rolando Rivas	Despacho Acevedo y Corrales	1994-09-16
YIQ9809042LM	Lic. Cornelio Loera	Duarte Salazar y Guevara	1978-10-08
LAY981029HYE	Hernán Oswaldo Barrera	Verdugo-Rosales S. R.L. de C.V.	2006-07-05
IHV120205E4X	Lic. Clemente Niño	Huerta S.A.	2016-06-01
BVH220531L8C	Diego Maya Riojas	Corporacin Dávila-Avilés	1995-05-23
NDW2404175BG	Linda Moya Arriaga	Corporacin Tamayo Bermúdez y Serrano	1990-01-09
OWC121130TBH	Bernardo Timoteo de la Fuente Tórrez	Mata-Madera S.A. de C.V.	2023-06-24
RQM130507RAT	Ariadna Téllez Venegas	Colón-Alcántar S.A.	2012-02-05
VTH1503249QM	Ing. Omar Patiño	Curiel-Canales S.A.	1987-05-09
KOM200421TXH	Dulce María Escobedo	Perales-Rincón	1982-01-12
FHB150905856	Cristobal Adán Rosado	Marrero-Naranjo S.A.	2006-11-28
SJL220917JRH	Lic. Indira de León	Despacho Casanova Garibay y Cazares	2024-01-29
RJQ260224B9Y	Gabino Iván Castillo Fuentes	Despacho Pizarro-Carrasco	1982-02-15
KZD0304217FL	Óliver Prado Arias	Despacho Apodaca y Serna	2017-03-14
XAS1408148UU	Modesto Casanova Hernandes	Barraza S.A. de C.V.	2022-04-06
GKA15091421A	Bernardo Castañeda Zarate	Industrias Feliciano y Escalante	2022-06-20
BMU1909080O3	Alicia Bustamante Concepción	Industrias Montero Mora y Cruz	2010-11-26
GTW030904CQZ	Srita. Mayte Vargas	Camacho-Véliz	1977-10-14
TYH0401150AX	Dulce Espinosa	Grupo Terrazas Acuña y Camacho	1991-05-26
BNH97071930L	Wendolin Roldán	Villalpando-Escalante S.C.	2022-09-01
TTL130318XMC	Espartaco José Ojeda	Gallegos Serrano y Gil	2004-07-27
NKD111129NGW	Jacobo Cornelio Robledo	Solís-Chacón	2010-07-29
SCV040623P15	Virginia Lomeli Valdés	Borrego S.A. de C.V.	2010-06-07
FXN980308W22	Juan Carlos Horacio Reyes	Laboratorios Quiroz Gastélum y Urrutia	2004-07-20
OVV051108PT5	Lic. Eugenio Barrios	Nazario y Duarte A.C.	2022-09-17
WDZ201008P3J	Tania Aurora Ortiz Quezada	Casares-Collazo	2003-09-14
QJE120311TT0	Verónica Paulina Canales	Despacho Narváez-Farías	1999-11-17
LVI03042418O	Teodoro Páez	Gonzales-Pineda	2026-03-08
NKQ0304174YC	Eugenia Yeni Verdugo Villaseñor	Proyectos Pabón Moya y Rolón	2022-03-15
IHL05022152W	Ing. Mariana Segura	Grupo Rentería Cardenas y Casillas	1993-11-22
FDS03101374L	Marisol Eloisa Cervantes Anguiano	Avilés-Barreto	2010-09-25
XQP070107AJ2	Ernesto Olivas Zedillo	Corral-Madrigal S. R.L. de C.V.	2019-03-31
MWH040428Z36	Augusto Ramiro Salcedo	Ferrer y Lozada e Hijos	2010-09-19
LPI04032800E	Mayte Esperanza Torres Montalvo	Aparicio S.C.	1984-12-10
OZO970128EIH	Margarita Graciela Ocampo	Rico y Aranda A.C.	1988-11-14
SSW061205CDP	Sofía Madrigal	Club Prado-Cervantes	1998-02-05
NXU080915YWE	Mariana Beatriz Varela	Urrutia y Tirado S. R.L. de C.V.	2008-10-21
OEJ120920EKR	Noemí Celia Santillán Badillo	Irizarry Saldaña y Villareal	2002-07-18
KOF260130FJ7	Dra. Eva Mayorga	Amaya S. R.L. de C.V.	1979-11-27
CMW070804XYF	José Emilio Jos Vergara Amador	Olivares-Calderón S.C.	2000-04-27
CCT060715VN8	Lilia Montoya Badillo	Grupo Gollum y Marrero	2017-02-26
GQP210821HDK	Antonio Iván Carrero	de la O-Almonte S. R.L. de C.V.	1999-01-10
PUR2007134XK	Maximiliano Pichardo Vanegas	Jaramillo Almonte y Rodarte	2016-11-05
OCL150413MRU	Jaime Ocasio Vásquez	Medrano Vega y Calvillo	2010-01-25
VUK100713RWI	Felix Jonás Salgado	de la Crúz-Luna S.A. de C.V.	2006-07-03
WXV170621SDY	Pablo Benítez	Corporacin Jaimes y Arreola	1997-01-24
JNX980716G29	Ing. Elena Caballero	Villarreal-Miramontes	1995-06-09
RSU210810C9R	Rufino Raúl Roldán	Fuentes Montenegro y Bermúdez	2021-03-04
SJZ140210DDE	Ing. Marcos Tirado	Feliciano-Pedroza S.C.	1993-12-07
EDI110325IJI	Lic. María Trujillo	Despacho Sevilla-Escobar	2016-02-02
YBM160915K4L	Dolores Soledad Robles Jasso	Valles Balderas y Solorio	1990-06-28
TPB181211MC9	María del Carmen Cordero Guajardo	Laboratorios Macías-Puga	2004-10-02
XSI220713E6K	Anabel Figueroa Paz	Proyectos Llamas Cruz y Hidalgo	2023-07-29
TIC110701ALM	Srita. Leonor Griego	Cornejo-Espinosa	1978-09-20
YUH240806EYN	Jacinto Rivera	Valencia y Pulido S.C.	2020-11-09
PXZ010414HU7	Felipe Crespo Laboy	Despacho Holguín-Ledesma	2021-08-28
RPF000326AGK	Conchita Arias	Almonte y Baca y Asociados	1982-07-19
SCU010209AT7	Raquel Lugo Barela	Narváez Bustamante y Osorio	2026-02-12
PEG210925UI9	Genaro César Vásquez Sanches	Solorio-Vera	2012-07-30
CNV100529QSQ	Lic. Bernabé Granados	Marroquín-Mendoza	2016-08-06
AFC990104BVZ	Elsa Lorena Gamez	Despacho del Río-Gallegos	1995-07-08
PFD210901F0V	Leticia Esparta Villalpando Badillo	Tejeda y Noriega e Hijos	1984-07-09
PEH051113YE0	Natividad Piña Roldán	Corporacin Colunga y Naranjo	2009-03-04
GRP2011305G1	Georgina Alonso Zelaya	Ayala e Hijos	2022-07-15
OCC98072113N	Gilberto Urías	Mares Naranjo y Casas	2013-03-27
ZZY150928E4U	Martín Oquendo	Orozco S.A. de C.V.	1997-04-23
GIU251019Z0L	Genaro Isaac Gaitán	Club Mateo-Palomo	1979-02-21
IGD170128FY3	Sr. Óscar Rodríguez	Mercado Pichardo y Camarillo	1987-09-30
AYZ981101E9R	Sr. José Peres	Rendón-Amaya y Asociados	1980-05-18
SSG171219KIB	Martín Daniel Acosta Pacheco	Laboratorios Magaña y Martínez	2016-01-07
PPM970223B7F	César Eloy Haro	Proyectos Villegas-Partida	1998-07-27
NFL040208HJ3	María Luisa Carla Hurtado Delgadillo	Lerma-Farías A.C.	2005-01-15
VHH150425RZD	Cristal Orozco Ocasio	Despacho Altamirano y Valdez	2020-11-13
NNP050417UQO	Srita. Araceli Ríos	Corporacin de la Garza y Arroyo	2004-02-15
JXE090922OKZ	Ing. Pilar Hurtado	Despacho Nazario-de la Rosa	2015-06-08
SCN020310IRC	Adalberto Ramón Puga	Saldaña y Casanova S.A.	2025-05-23
DAV0411019E3	Eugenio Jáquez	Laboratorios Saldaña Olivas y Cedillo	2006-03-09
AJC110331VLN	Timoteo Galván	Laboratorios Esparza Peralta y Dueñas	2004-08-19
COP000307TYT	Aldo Humberto Iglesias Gracia	Guzmán y Negrón S. R.L. de C.V.	2023-05-26
FFB000103MKT	Antonia Adela Rodarte Cepeda	Otero-Galindo e Hijos	2002-12-06
YJY130510LA1	Perla Esparta Beltrán	Valdés-Bahena	1980-05-19
KIK981011ZJC	Elsa Rodríguez Moreno	Adame S.A. de C.V.	2011-03-03
JRT19050981A	Ing. Gabriela Ortega	Centeno-Valdivia A.C.	2016-05-03
KLT260226IQ2	Gregorio Enrique Santacruz Salcedo	Rocha-Centeno A.C.	1998-06-05
EZS04121472I	Lucía Collado	Despacho Marroquín Armendáriz y Cavazos	2010-10-21
RCI140116T8V	Ing. Marcos Leyva	Industrias Jaime Sierra y Marroquín	2006-06-28
TEZ26102083E	Jacobo Óscar Corona Valadez	Avilés y Esparza S.A.	1980-07-19
XUU001004VXY	Espartaco Aranda	Hurtado y Dávila e Hijos	2008-08-15
SQD120424OY4	Berta Marisol Arevalo	Munguía y Valentín S.C.	2007-12-26
IPO260402RMY	Beatriz Yuridia Cordero Castañeda	Cabán-Figueroa y Asociados	1996-03-02
YYO060712DKT	Enrique Pedro Laboy Valladares	Industrias Acuña y Sotelo	2015-09-05
ZCR190314J37	Luis Manuel Augusto Gurule Samaniego	Méndez-Alvarez	1996-03-06
CGF050914SA7	Julio César José Manuél Villanueva	Mejía-Corrales	1978-10-19
SBD150308LOS	Maximiliano Octavio Rendón	Industrias Adame Mendoza y Armas	2021-06-27
OYG110309OGX	Ing. Helena Varela	Grupo Arriaga-Leyva	1998-10-29
NKK090528FV1	Arturo Trujillo Zarate	Caballero Ozuna y Herrera	1988-12-12
IGT25031476A	Leonel Burgos	Frías S.A.	2003-04-10
GPF0408156T1	Eva Sessa Corrales	Lugo-Salas	2006-04-04
EOZ2408194XY	Dr. José Carlos Caldera	Sepúlveda-Feliciano S.C.	2007-02-23
ISH220621J49	María José Estela Valladares	Bustamante Pichardo y Negrete	2018-08-10
KNX080517YT2	Mariano Marco Antonio Cabán Arevalo	Rivas-Garrido e Hijos	2023-07-14
NRV260916NXV	Oswaldo Ramón Sosa Botello	Club Quesada Bétancourt y Romo	1997-04-11
TRM020628UJO	Cristian Isaac Guzmán Solorzano	Lucero Varela y Arreola	2014-05-01
IWD23070611E	Alonso Porfirio Cardenas	Paz Cabrera y Rivera	2021-10-21
JNR191022J9B	Dra. Irma Hernández	Santacruz-Alemán	1984-08-02
JQQ100727UJ3	Conchita Cristal Orozco Armenta	Peña-Luevano	1998-03-14
KQE070215H30	Ing. Susana Rascón	Corporacin Escobar Galarza y Escalante	1982-02-27
XZK150716R78	Dra. Tania Caraballo	Téllez Almanza y Adame	2003-09-17
JGC981127U0I	Adalberto Enrique Romero	Palacios y Zarate e Hijos	2009-12-15
EJT990420T6D	Ing. Leonardo Madrid	Castillo-Cervántez	1977-10-11
PKD080128LN4	César Alemán	Proyectos Amador y Fuentes	2009-07-29
COE1502155NQ	Gerardo Mariano Tijerina Espino	Madera-Rivas	1986-12-01
HDE081120QTO	Lorena Alejandra Carrión de la Crúz	Laboratorios Rael-Rubio	2008-12-01
VZN251215RYO	Mauricio Vigil Guerra	Corporacin Vargas y Orosco	1980-04-19
HZQ190528PNM	Adela Candelaria Preciado	Saldivar Véliz y Ybarra	2026-08-02
KYW010314RH8	Florencia Arce	Pabón y Ruelas S. R.L. de C.V.	2017-01-20
KOZ210611IY4	Ing. Eloisa Ballesteros	Pichardo S. R.L. de C.V.	1998-04-30
WYR0604221O4	Anabel Jasso	Rojas Carrión y Saldaña	2019-03-18
VKA050317YGH	Marcela Pulido Alonso	Corporacin Espinosa-Rodarte	2000-03-26
YJY210314ODK	Eloisa Mayte Gaona Villagómez	Zarate-Rocha S.A.	1996-10-19
HVN141030WEB	Liliana Tania Murillo	Cuellar y Franco S.A. de C.V.	2023-11-02
WXJ140611YXT	Óliver Cristobal Delgadillo	Grupo Zelaya y Salazar	1983-09-13
BZF16090942M	Marisol Gabriela Gollum	Industrias Arreola y Almanza	2001-04-01
ILB260220MAE	Ing. Eloy Delgado	Barela S.A. de C.V.	2006-02-20
ETU260708U1G	Wilfrido Gabino Casárez	Club Holguín y Molina	2001-01-03
USC190403FZW	Rodrigo Jaramillo Corona	Arteaga-Quezada	2007-12-11
VIB160319QGU	Carlos Vicente Canales	Sarabia A.C.	1988-03-14
HBF0302262VF	Felix José Eduardo Cortez	Laboratorios Quintanilla Santillán y Samaniego	2026-09-07
DEY07071028X	Elias José Emilio Mesa	Despacho Ferrer-Quiñones	2005-02-15
YMC230627RVT	Germán Rojo Mondragón	Industrias de la Torre Briones y Jáquez	2002-03-06
MRR990330J38	Isabela Ruby Guillen	Proyectos Tamayo-Pérez	1992-05-12
EZW070806RLR	Marco Antonio Luis Parra Reynoso	Anguiano-Quintero S.A.	1977-07-06
SYX130101G5G	Andrea Bravo	Mascareñas-Padilla y Asociados	1988-01-07
MOG181026N3O	Ana María Karina Arce	Industrias Baeza-Solís	1996-12-16
GMR0005103OD	Laura Trinidad Uribe	Laboratorios Martínez Montañez y Aguilera	1995-11-15
PJS970502WFF	Reina Contreras	Ramírez Flórez y Tovar	2019-04-28
MFC141014FQJ	Ing. Victoria Montaño	Fajardo Madera y Bravo	1979-05-08
QWT160405DNT	Hilda Orellana	Industrias Toledo-Limón	1991-05-19
XEC120604HGZ	Pedro Rodolfo Marrero	Crespo-Altamirano A.C.	2013-07-30
SED1607152J5	Dra. Elvia Maestas	Santiago Carranza y Balderas	2002-03-20
MPM1312101H6	Ing. Cornelio Arreola	Rangel-Lugo	2015-10-15
NVG050407MJ7	Mauro Mojica Gracia	Corporacin Luna y Linares	2022-03-21
UIK161107FN1	Srita. Yeni Ocasio	Despacho Menchaca y Sevilla	2016-06-18
HDP110928YB6	José Eduardo Rentería	Contreras-Pizarro	2004-11-15
YBY090715BO1	Bernabé Ángel Pizarro	Club Gallegos-Ramírez	1982-02-23
MXO041205XCB	Teresa Sotelo Padrón	Jaime Viera y Samaniego	2020-02-23
MWM010504C6Z	Luz Vanesa Saiz	Curiel Colón y Santiago	1985-06-26
\.


--
-- TOC entry 3605 (class 0 OID 57359)
-- Dependencies: 234
-- Data for Name: reporte_norm; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reporte_norm (id_reporte, fecha_reporte, id_notario) FROM stdin;
1003	2026-10-18 09:00:00	71
1001	2026-10-05 10:30:00	54
1002	2026-10-12 14:15:00	54
\.


--
-- TOC entry 3597 (class 0 OID 16868)
-- Dependencies: 226
-- Data for Name: reporte_uif; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reporte_uif (id_notario, id_reporte, tipo_reporte, fecha_recepcion, monto_total) FROM stdin;
151	1	Operación Relevante	2026-03-15	8535282.54
9	2	Operación Inusual	2026-04-15	2347684.03
85	3	Aviso de Actividad Vulnerable	2026-10-30	14703573.13
53	4	Aviso de Actividad Vulnerable	2026-10-27	1002453.26
99	5	Operación Inusual	2026-10-31	7147925.94
85	6	Aviso de Actividad Vulnerable	2026-10-27	9603099.42
78	7	Operación Relevante	2026-05-03	2612783.71
173	8	Operación Inusual	2026-07-13	529284.35
177	9	Aviso de Actividad Vulnerable	2026-09-28	451235.65
51	10	Operación Relevante	2026-07-29	13674612.39
99	11	Operación Preocupante	2026-10-17	3128089.83
75	12	Operación Relevante	2025-12-09	6847222.12
95	13	Operación Relevante	2026-08-12	2618794.47
106	14	Aviso de Actividad Vulnerable	2026-03-29	2397680.05
29	15	Operación Inusual	2026-02-22	8069972.64
123	16	Operación Relevante	2026-06-23	5865443.82
53	17	Operación Inusual	2026-01-14	13063213.56
80	18	Aviso de Actividad Vulnerable	2026-08-03	12277546.74
171	19	Aviso de Actividad Vulnerable	2025-12-25	2423779.69
148	20	Operación Preocupante	2026-10-03	8833004.70
129	21	Aviso de Actividad Vulnerable	2026-05-20	4167842.61
2	22	Operación Inusual	2026-10-06	6713687.13
103	23	Operación Inusual	2026-06-10	7911554.75
146	24	Aviso de Actividad Vulnerable	2026-08-31	6930058.17
148	25	Operación Relevante	2026-09-28	11072496.13
74	26	Aviso de Actividad Vulnerable	2026-08-05	5234388.51
183	27	Operación Preocupante	2026-05-14	5896801.00
45	28	Aviso de Actividad Vulnerable	2025-11-12	3774565.52
159	29	Aviso de Actividad Vulnerable	2025-12-19	6894530.87
169	30	Operación Inusual	2026-05-12	10492904.43
25	31	Aviso de Actividad Vulnerable	2026-09-05	10494739.12
12	32	Operación Inusual	2025-12-03	13288850.18
41	33	Operación Preocupante	2026-02-25	13244209.69
138	34	Operación Preocupante	2026-09-19	10016521.26
18	35	Operación Inusual	2026-07-19	13635610.24
106	36	Operación Relevante	2026-06-01	14929979.90
20	37	Operación Relevante	2026-10-05	7590702.89
200	38	Operación Preocupante	2026-04-30	6180936.21
43	39	Operación Preocupante	2026-01-04	3150212.83
12	40	Aviso de Actividad Vulnerable	2026-10-14	449432.30
164	41	Aviso de Actividad Vulnerable	2026-04-22	5748275.74
191	42	Aviso de Actividad Vulnerable	2025-12-14	12843808.52
102	43	Operación Relevante	2026-05-06	210523.55
30	44	Operación Inusual	2026-07-15	4940299.92
192	45	Aviso de Actividad Vulnerable	2026-05-28	7297150.60
18	46	Operación Relevante	2026-02-01	8249006.68
63	47	Aviso de Actividad Vulnerable	2026-02-02	2146823.61
72	48	Operación Inusual	2026-01-21	2600306.98
5	49	Operación Relevante	2026-01-05	2699687.23
32	50	Aviso de Actividad Vulnerable	2026-08-19	2568377.94
172	51	Operación Relevante	2026-07-14	10176877.97
40	52	Aviso de Actividad Vulnerable	2026-07-29	5403400.50
56	53	Operación Relevante	2025-12-04	13395681.20
137	54	Operación Inusual	2025-12-10	6658769.25
13	55	Operación Relevante	2026-04-17	5889744.92
79	56	Aviso de Actividad Vulnerable	2026-08-04	833608.08
2	57	Operación Relevante	2025-11-11	11597524.94
197	58	Operación Inusual	2026-01-01	13935867.26
96	59	Operación Inusual	2026-10-26	3039786.08
5	60	Aviso de Actividad Vulnerable	2026-10-26	467765.34
4	61	Operación Preocupante	2026-03-06	12316871.91
175	62	Operación Relevante	2026-10-16	3347489.39
25	63	Operación Inusual	2026-03-28	10873971.88
12	64	Aviso de Actividad Vulnerable	2026-08-24	7711876.50
84	65	Operación Preocupante	2026-02-16	8452709.05
49	66	Operación Inusual	2026-01-24	14018194.15
102	67	Aviso de Actividad Vulnerable	2026-08-06	1856019.22
55	68	Operación Relevante	2026-02-08	5380816.07
45	69	Operación Relevante	2026-07-16	6061985.37
81	70	Operación Relevante	2026-05-03	5868340.56
118	71	Operación Inusual	2026-10-14	1036943.45
72	72	Operación Preocupante	2026-07-18	706887.19
56	73	Aviso de Actividad Vulnerable	2025-12-17	4557937.02
154	74	Aviso de Actividad Vulnerable	2026-07-16	14747382.27
27	75	Operación Inusual	2025-12-22	3816505.29
25	76	Operación Preocupante	2026-10-24	14722167.63
179	77	Aviso de Actividad Vulnerable	2026-05-26	10184612.81
198	78	Operación Inusual	2026-07-04	5014095.88
163	79	Operación Preocupante	2026-08-08	14671421.89
171	80	Aviso de Actividad Vulnerable	2026-05-10	1059326.58
5	81	Aviso de Actividad Vulnerable	2025-12-05	5766452.42
164	82	Operación Inusual	2026-09-04	7576129.66
181	83	Operación Relevante	2026-07-26	3527458.27
158	84	Operación Relevante	2026-03-09	4667287.00
189	85	Aviso de Actividad Vulnerable	2026-10-04	11370823.87
159	86	Operación Relevante	2026-01-25	945849.10
96	87	Aviso de Actividad Vulnerable	2026-10-27	4484390.22
39	88	Aviso de Actividad Vulnerable	2026-06-11	3105560.68
10	89	Operación Inusual	2026-08-24	13854966.64
154	90	Aviso de Actividad Vulnerable	2026-10-24	11101871.76
85	91	Operación Inusual	2026-06-21	4207990.33
165	92	Operación Relevante	2025-11-25	7837049.25
107	93	Operación Preocupante	2026-07-08	11270736.12
59	94	Operación Preocupante	2026-03-13	5173789.81
53	95	Operación Relevante	2026-03-26	13604149.26
171	96	Operación Inusual	2026-10-19	12031704.52
179	97	Operación Inusual	2026-08-05	9140544.81
98	98	Operación Preocupante	2026-08-15	2794004.83
162	99	Operación Relevante	2026-08-12	1016022.36
126	100	Operación Relevante	2026-08-08	14307234.79
14	101	Operación Inusual	2026-03-28	14077204.17
33	102	Operación Relevante	2026-07-11	2646453.58
141	103	Operación Inusual	2026-07-07	3582836.42
21	104	Aviso de Actividad Vulnerable	2026-08-31	10888587.12
80	105	Operación Inusual	2026-06-06	10839022.80
63	106	Aviso de Actividad Vulnerable	2026-09-28	2687710.80
64	107	Operación Preocupante	2026-04-18	4316025.71
115	108	Operación Inusual	2026-09-09	4114318.73
124	109	Operación Relevante	2026-01-29	14267647.23
93	110	Aviso de Actividad Vulnerable	2026-01-25	5696876.46
121	111	Aviso de Actividad Vulnerable	2026-02-08	6369324.00
157	112	Aviso de Actividad Vulnerable	2025-12-14	11416850.74
124	113	Operación Relevante	2026-02-21	11440843.02
110	114	Operación Relevante	2025-12-04	11394931.92
77	115	Operación Inusual	2025-12-13	8315139.45
45	116	Operación Preocupante	2025-12-04	5737731.05
79	117	Aviso de Actividad Vulnerable	2026-03-12	4284224.93
144	118	Aviso de Actividad Vulnerable	2026-08-14	1125497.76
35	119	Aviso de Actividad Vulnerable	2026-06-17	2975950.45
49	120	Operación Relevante	2026-10-29	241872.37
129	121	Operación Preocupante	2026-01-12	7397233.08
107	122	Aviso de Actividad Vulnerable	2026-08-16	14558864.92
96	123	Aviso de Actividad Vulnerable	2026-10-31	7368789.16
165	124	Operación Relevante	2025-12-15	6161374.39
10	125	Operación Relevante	2026-06-10	5803148.87
145	126	Operación Inusual	2026-03-22	2953711.60
112	127	Operación Preocupante	2025-12-19	11580492.16
193	128	Operación Preocupante	2026-09-27	7668645.03
126	129	Operación Preocupante	2026-03-01	10462008.41
167	130	Aviso de Actividad Vulnerable	2026-03-27	13901455.41
189	131	Operación Inusual	2026-06-12	3673175.39
9	132	Operación Preocupante	2026-08-13	9482743.07
174	133	Operación Relevante	2025-10-31	10477197.77
166	134	Operación Inusual	2026-02-28	3956893.94
117	135	Operación Inusual	2025-11-24	3851606.12
155	136	Operación Inusual	2026-06-17	234443.94
198	137	Operación Relevante	2026-05-27	9683740.99
99	138	Aviso de Actividad Vulnerable	2026-01-12	10605743.09
21	139	Operación Inusual	2026-09-24	13146292.19
43	140	Aviso de Actividad Vulnerable	2026-03-30	3830424.97
78	141	Aviso de Actividad Vulnerable	2026-04-13	8811892.58
188	142	Aviso de Actividad Vulnerable	2026-03-04	11299310.67
187	143	Operación Relevante	2026-08-26	1683647.37
147	144	Operación Preocupante	2026-03-21	12222708.92
69	145	Operación Inusual	2026-09-05	13953752.15
102	146	Operación Preocupante	2026-07-21	145983.59
44	147	Aviso de Actividad Vulnerable	2026-10-28	73599.73
18	148	Aviso de Actividad Vulnerable	2026-09-05	7898181.73
168	149	Operación Preocupante	2025-12-19	11008981.43
44	150	Operación Inusual	2026-05-20	5651038.26
181	151	Operación Inusual	2026-07-15	3010406.91
47	152	Operación Relevante	2026-06-21	6787378.73
55	153	Operación Inusual	2026-06-17	3054065.68
192	154	Operación Inusual	2026-01-25	12147220.46
50	155	Operación Preocupante	2025-12-11	14745059.52
105	156	Aviso de Actividad Vulnerable	2026-04-02	9421218.82
160	157	Operación Relevante	2025-11-03	13032011.78
43	158	Operación Relevante	2026-05-28	4432227.50
97	159	Operación Relevante	2026-09-27	4187594.93
88	160	Operación Relevante	2026-04-27	8805413.68
123	161	Aviso de Actividad Vulnerable	2026-03-02	10108428.65
26	162	Operación Relevante	2025-12-26	962794.18
193	163	Operación Relevante	2026-09-12	9996568.06
11	164	Operación Relevante	2026-02-23	3205471.96
2	165	Aviso de Actividad Vulnerable	2026-09-21	9064623.83
195	166	Operación Preocupante	2026-01-24	13985319.29
122	167	Operación Preocupante	2026-05-13	9085354.69
87	168	Operación Preocupante	2026-07-22	10243806.99
88	169	Operación Preocupante	2026-04-26	12261865.52
93	170	Aviso de Actividad Vulnerable	2025-12-27	5707613.69
15	171	Operación Preocupante	2026-06-21	13102507.61
26	172	Operación Relevante	2026-02-18	6880942.93
179	173	Aviso de Actividad Vulnerable	2025-12-26	10892041.80
36	174	Operación Relevante	2026-08-17	9048542.19
136	175	Operación Preocupante	2026-07-16	14268375.99
193	176	Operación Inusual	2026-09-25	5558026.93
159	177	Aviso de Actividad Vulnerable	2026-09-07	7747964.32
170	178	Operación Inusual	2026-09-17	96780.19
164	179	Operación Preocupante	2026-07-31	298623.05
93	180	Operación Relevante	2025-11-13	14545483.77
189	181	Operación Preocupante	2026-06-20	10185044.82
60	182	Aviso de Actividad Vulnerable	2026-03-04	6032469.60
157	183	Operación Relevante	2026-02-27	5257592.67
122	184	Operación Relevante	2026-05-14	11027452.26
76	185	Operación Inusual	2026-07-25	10693532.50
134	186	Operación Relevante	2025-12-17	1961527.25
23	187	Operación Preocupante	2026-02-14	12493693.96
141	188	Aviso de Actividad Vulnerable	2026-09-25	2562390.13
115	189	Operación Relevante	2026-08-01	7258419.75
139	190	Operación Inusual	2026-06-10	3688172.18
44	191	Operación Relevante	2026-05-04	1626771.67
184	192	Operación Relevante	2026-07-03	2445517.40
84	193	Aviso de Actividad Vulnerable	2026-09-17	11506316.92
57	194	Operación Preocupante	2026-01-22	10005693.58
172	195	Operación Relevante	2026-05-11	9998871.70
137	196	Aviso de Actividad Vulnerable	2026-02-21	1402104.23
178	197	Operación Preocupante	2026-07-31	13085512.07
148	198	Operación Relevante	2026-03-26	9677598.78
97	199	Aviso de Actividad Vulnerable	2025-11-22	9826098.76
144	200	Aviso de Actividad Vulnerable	2026-09-10	12136289.86
\.


--
-- TOC entry 3591 (class 0 OID 16806)
-- Dependencies: 220
-- Data for Name: telefono; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.telefono (rfc, numero) FROM stdin;
\.


--
-- TOC entry 3599 (class 0 OID 16891)
-- Dependencies: 228
-- Data for Name: transaccion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transaccion (id_transaccion, cuenta_origen, cuenta_destino, monto, fecha_hora) FROM stdin;
1	5361783134534717	2801661046809953	829603.47	2026-03-28 07:56:33
2	4276008057789597	5707724124526482	306380.94	2025-04-07 12:57:23
3	9059231552006101	5196467046957649	931484.51	2024-12-31 08:41:59
4	8229000143163782	9579316708782282	521740.29	2026-02-04 12:02:03
5	7211839604663300	6521020379366730	212258.31	2025-02-27 13:47:19
6	9603287267815461	9250874671579898	219296.96	2025-01-20 04:03:26
7	4465798586728229	6521020379366730	975999.40	2026-05-22 16:53:38
8	6385728302345922	1615527097233863	816650.56	2025-04-18 07:12:06
9	4021165837964462	4668471385517723	313533.07	2025-06-06 15:44:56
10	8496544091512283	2890078206365293	827340.05	2025-03-19 16:39:50
11	4985724512556360	9742616360065707	803437.59	2025-05-24 09:57:09
12	7053698385783542	5196467046957649	195133.22	2026-01-12 23:49:11
13	4207440345978338	7188366313795421	78269.67	2025-01-19 15:51:46
14	6385728302345922	8126669414300840	846685.97	2025-02-07 14:22:32
15	2519726837930131	2745730319204663	282565.83	2026-07-13 03:26:37
16	8620717349777150	4207440345978338	65786.51	2025-12-11 21:08:59
17	2575297000249137	8161682681664771	756643.18	2026-01-31 08:49:25
18	3905783934171980	7288220242347356	551915.53	2026-03-17 00:56:42
19	6320364796726844	7004894604443727	240714.99	2026-06-19 04:43:41
20	6942850869373460	5631959940278586	565014.41	2025-08-25 15:04:50
21	4570179131607920	3097503640835944	46157.77	2025-07-15 15:04:20
22	5446967597850399	9579316708782282	943537.39	2026-01-22 07:26:25
23	8161682681664771	7899266730035121	751803.59	2026-06-23 19:09:57
24	2100590128581265	5707724124526482	195286.26	2026-08-26 00:58:24
25	4730728407555074	6998014831282551	725825.28	2026-02-04 03:17:19
26	7679088370052320	9837046094658472	674849.07	2026-02-13 22:16:02
27	7260337461383218	7244538328376944	896562.92	2025-06-04 12:31:18
28	5707724124526482	2615639639411028	502426.03	2026-07-21 05:35:42
29	4854736821927577	2233527547708157	24173.47	2026-05-27 20:03:56
30	9240434872035169	4668471385517723	586565.02	2026-09-08 23:19:53
31	4556143342533774	3769065173108798	161642.39	2026-02-22 13:24:34
32	5495584038141301	8411116574492332	79213.48	2026-04-04 10:07:33
33	7533366698248281	9579316708782282	952841.89	2026-10-08 09:42:40
34	1691996267280637	5731494318091287	807572.30	2025-11-03 21:23:00
35	4253069530642795	8667798689116415	768941.30	2025-04-12 18:12:00
36	9838773636178697	5707724124526482	516542.65	2025-03-11 18:02:24
37	3591273567853235	8611037787003687	651569.22	2024-11-03 06:13:38
38	9294794490987056	1740821903430309	447756.47	2026-07-02 15:25:14
39	7679088370052320	1438783977834992	291196.17	2025-04-30 06:05:02
40	9038275786724196	3534784549443219	40492.90	2025-04-18 07:14:19
41	2801661046809953	4854736821927577	683032.04	2025-01-11 03:06:32
42	2745730319204663	5450459302319412	997010.99	2026-10-24 04:27:15
43	8611037787003687	1615527097233863	958036.64	2026-07-18 04:02:27
44	5631959940278586	7533366698248281	994407.33	2026-02-21 19:26:55
45	9895349242796968	9737989689252528	143051.21	2025-02-22 23:14:33
46	3905783934171980	2551103138219285	867599.91	2025-02-20 12:22:02
47	4219039915603203	1263540703108165	94566.94	2025-03-09 04:52:39
48	5446967597850399	4825397826212336	934088.94	2025-11-05 11:43:53
49	9838773636178697	2006305614900248	280477.26	2026-09-11 12:25:43
50	6733630304384053	4927754316283648	89684.63	2024-11-01 09:02:32
51	2294493794222726	2252126257924898	772054.54	2025-07-10 07:53:42
52	7887706695651033	4826300802266222	978494.52	2024-12-31 14:30:10
53	8518688920737506	9558090000075949	650466.94	2026-09-28 02:13:15
54	5407595300107752	8525616525686056	971694.81	2024-12-11 17:19:02
55	6393169364662274	2794751456978560	363790.37	2025-02-15 13:50:16
56	8014877197360049	1869227312067828	409328.71	2025-12-03 15:19:03
57	9603287267815461	5495584038141301	129419.75	2026-07-21 04:22:47
58	6733630304384053	2182034351345457	844913.23	2025-10-08 16:50:15
59	5446967597850399	7557250290225738	83948.80	2025-09-27 14:34:40
60	9495817443909294	8204655962128844	450367.23	2026-04-01 13:59:51
61	5495584038141301	2794751456978560	620803.42	2025-11-02 13:21:43
62	8496544091512283	9250874671579898	741172.04	2025-07-13 05:49:40
63	7040232345328795	9837046094658472	821324.42	2025-06-24 04:32:10
64	8161682681664771	5486798008348449	853133.25	2025-11-24 20:06:29
65	3769065173108798	6394333181468890	158626.70	2026-06-14 12:00:20
66	1869227312067828	7705500634532075	223439.76	2025-01-31 07:00:19
67	8411116574492332	4258440270832295	93956.37	2025-05-07 04:46:20
68	4021165837964462	8496544091512283	535348.20	2026-01-10 06:18:08
69	4021165837964462	4207440345978338	86279.64	2025-09-02 15:05:21
70	2667463454500130	4207440345978338	917501.62	2025-08-21 06:00:00
71	2100590128581265	9294794490987056	433397.84	2026-06-25 07:20:51
72	1869227312067828	7260337461383218	64939.29	2025-08-27 15:14:15
73	1740821903430309	6385728302345922	486551.87	2026-05-03 17:47:37
74	9837046094658472	3337702790055514	476481.36	2025-11-04 17:21:04
75	4884333020521633	7630869442961520	38763.20	2025-08-03 21:57:50
76	5486798008348449	7178154238728514	145941.04	2025-07-01 08:06:07
77	4759119075699849	3034484965218178	568422.47	2026-08-14 13:59:55
78	9290919888041559	4854736821927577	380594.68	2025-12-11 14:57:32
79	6221936982655407	3534784549443219	978571.54	2025-07-05 09:13:30
80	4759119075699849	9742616360065707	211887.14	2025-12-18 09:08:06
81	5418802171918600	9167668404995589	683829.60	2024-12-31 22:11:15
82	8229000143163782	5681287193177625	635869.45	2026-09-18 06:04:38
83	6942850869373460	8667798689116415	69724.42	2026-02-14 09:33:35
84	2890078206365293	9183304779050921	298687.63	2026-08-17 08:01:21
85	2801661046809953	1256187260466201	871353.49	2025-04-16 07:48:48
86	5225114202440119	4759119075699849	669809.58	2025-03-10 05:04:21
87	7887706695651033	4465798586728229	830633.82	2026-03-08 10:46:01
88	9579316708782282	8478788124818546	342348.14	2026-08-10 15:57:45
89	4730728407555074	5465911873087264	164951.01	2025-06-04 21:49:43
90	9324742260160401	5275857731322057	481884.44	2026-05-07 16:55:19
91	7645495950711693	1966693877642406	783965.46	2025-02-20 03:59:27
92	1092525052752289	4743480578496773	355015.03	2026-08-15 12:51:56
93	3498377931341988	4276008057789597	389443.40	2025-10-06 19:14:42
94	8161682681664771	6753853480954258	783180.84	2026-01-10 12:39:14
95	2575297000249137	4253857612488245	78269.81	2025-10-10 05:20:01
96	2115032704873526	8382177329118578	616704.12	2025-11-16 20:26:43
97	8575866941300411	2115032704873526	986374.76	2026-04-25 02:02:19
98	2667463454500130	6521020379366730	825322.32	2026-07-06 23:48:53
99	2667463454500130	3034484965218178	14679.68	2025-05-14 18:49:35
100	4671132863528505	7447455512899469	499695.95	2026-04-17 12:37:05
101	3034484965218178	1295369658985347	792120.81	2025-02-02 13:52:21
102	7418053520124860	7244538328376944	263171.29	2026-01-08 12:32:41
103	9894818877545874	3607252946789883	988244.49	2026-10-01 01:13:19
104	7211839604663300	3731260790264202	449603.99	2025-10-05 09:08:01
105	8382177329118578	9895349242796968	36967.73	2026-03-22 16:19:06
106	6521020379366730	7288220242347356	420466.02	2025-07-29 14:59:42
107	6239074821528375	4854736821927577	166517.98	2025-03-19 10:49:55
108	6394333181468890	5731494318091287	348411.51	2024-11-20 19:59:00
109	7288220242347356	4819881118987207	577048.01	2026-09-04 22:25:51
110	9737989689252528	9871750119198657	813872.46	2025-08-12 05:20:35
111	9458497750856794	9405092368447150	896706.59	2026-08-27 13:44:09
112	5707724124526482	8525616525686056	699467.49	2025-10-29 04:43:27
113	4384656520065231	7630869442961520	414346.70	2026-06-22 20:09:51
114	4927754316283648	8620717349777150	426136.27	2026-04-05 14:52:27
115	8518688920737506	8602343777360470	113823.31	2025-07-27 22:11:25
116	2294493794222726	4671132863528505	428669.42	2026-05-21 00:30:22
117	2294493794222726	5361783134534717	595094.36	2025-09-26 13:49:33
118	8620717349777150	4743480578496773	381872.54	2025-04-16 05:35:15
119	6347125113691756	1966693877642406	680441.70	2026-02-23 09:40:22
120	3731260790264202	1169389549057533	702241.58	2026-01-09 23:45:25
121	2615639639411028	4219039915603203	806036.79	2026-09-12 19:45:35
122	7188366313795421	4219039915603203	649799.77	2026-10-17 05:47:00
123	9902558709989114	9495817443909294	104123.46	2026-10-31 20:15:31
124	7721155004785019	4730728407555074	624013.78	2025-03-29 12:38:25
125	6239074821528375	2615639639411028	633708.39	2025-08-25 05:57:47
126	5707724124526482	8382177329118578	805967.71	2025-08-18 20:08:35
127	2115032704873526	3769065173108798	851779.40	2025-03-20 05:20:47
128	4759119075699849	6420463132740625	776991.81	2026-10-27 00:24:29
129	5361783134534717	9240434872035169	114943.85	2026-06-04 21:14:43
130	7178154238728514	8525616525686056	350938.38	2024-11-09 11:23:19
131	8411116574492332	9495817443909294	908039.57	2025-04-02 07:05:22
132	7053698385783542	4136397632451833	784742.85	2025-10-10 13:25:09
133	2100590128581265	5327830586440160	939647.00	2025-08-08 13:48:26
134	6420463132740625	8204655962128844	283962.62	2025-12-14 17:50:21
135	6347125113691756	8996635230804221	307742.99	2025-04-01 13:25:38
136	3323061345610514	7418053520124860	241933.66	2024-11-05 13:06:10
137	3323061345610514	7004894604443727	16022.30	2026-01-30 11:47:03
138	5486798008348449	7557250290225738	840849.24	2025-06-30 06:32:32
139	7325441221999343	3337702790055514	600145.70	2025-07-14 07:13:15
140	8602343777360470	4825397826212336	959181.01	2025-01-13 06:44:58
141	3534784549443219	2745730319204663	555961.71	2026-10-09 19:28:15
142	6998014831282551	1158031497427759	616459.78	2025-08-14 16:37:38
143	6998014831282551	9742616360065707	801430.98	2026-10-13 12:19:19
144	7197376426551639	8478788124818546	129306.03	2025-05-17 06:52:32
145	3731260790264202	4980622148760275	977366.96	2025-11-26 17:11:15
146	6656793048257106	2890078206365293	904219.29	2026-10-17 23:38:15
147	7325441221999343	7678223610607232	437682.89	2024-11-11 06:40:31
148	2615639639411028	2252126257924898	801271.39	2026-02-15 11:32:06
149	8204655962128844	5606410340587623	631625.35	2025-06-01 06:02:52
150	6998014831282551	8518688920737506	627504.72	2024-11-27 05:27:03
151	7887706695651033	5361783134534717	159473.64	2026-03-18 21:27:37
152	8575866941300411	8032839298716593	93707.80	2025-06-02 17:54:22
153	3461930721037934	4743480578496773	12032.35	2026-03-14 14:06:42
154	3627073826096158	6292654721313792	153472.09	2025-11-08 00:42:18
155	9603287267815461	2252126257924898	543900.65	2025-09-06 13:10:43
156	9183304779050921	4276008057789597	382713.65	2024-12-05 07:07:10
157	6521020379366730	2667463454500130	130982.74	2026-04-25 09:28:57
158	7630869442961520	3731260790264202	631686.04	2026-05-02 04:52:54
159	7899266730035121	4465798586728229	240102.02	2025-05-16 17:24:34
160	2468436050437822	5465911873087264	194232.00	2025-06-02 03:24:39
161	7040232345328795	2387321691756654	780138.94	2026-03-01 20:19:32
162	6394333181468890	3627073826096158	260849.48	2024-12-15 15:13:43
163	9742616360065707	5547817354302636	83421.89	2026-01-19 14:39:56
164	8667798689116415	7533366698248281	23629.25	2026-08-02 16:20:38
165	8382177329118578	7188366313795421	111376.05	2024-11-24 19:37:52
166	2575297000249137	8525616525686056	107523.12	2026-09-02 15:22:51
167	1169389549057533	8996635230804221	894657.49	2026-05-12 21:28:49
168	9579316708782282	1615527097233863	494497.93	2026-10-22 15:41:18
169	6221936982655407	5450459302319412	391104.81	2025-11-01 20:57:41
170	5152715057209105	5418802171918600	414038.26	2026-02-16 01:55:24
171	6393169364662274	7533366698248281	76774.53	2026-03-07 06:14:58
172	7504429714945520	5275857731322057	375566.74	2025-10-20 04:34:29
173	5446967597850399	3731260790264202	908348.25	2025-11-17 00:18:13
174	9838773636178697	7224431152318297	299105.61	2025-03-16 03:45:57
175	2294493794222726	6347125113691756	567510.20	2025-11-03 22:09:30
176	8611037787003687	7004894604443727	117648.54	2026-06-06 16:15:37
177	1740821903430309	1059614525950970	484169.04	2026-09-11 18:26:41
178	9902558709989114	9290919888041559	546709.53	2026-03-19 03:37:08
179	7678223610607232	3744354007133134	741825.98	2026-06-07 04:23:02
180	8525616525686056	1158031497427759	606307.72	2025-12-29 22:55:31
181	7645495950711693	5418802171918600	518235.92	2026-07-21 08:02:21
182	9167668404995589	5486798008348449	216698.38	2025-01-20 21:02:22
183	6733630304384053	1295369658985347	898623.09	2024-11-30 20:25:13
184	2519726837930131	4309618815797571	138995.74	2025-08-15 05:03:02
185	6942850869373460	3591273567853235	691755.92	2024-11-23 14:00:01
186	7211839604663300	7887968414238445	274029.65	2026-02-20 06:06:22
187	6115334869827455	9579316708782282	348879.10	2026-09-26 18:45:02
188	5361783134534717	4384656520065231	294673.72	2026-05-09 05:30:39
189	6521020379366730	8702397469739269	436343.96	2025-02-28 04:08:29
190	1869227312067828	1158031497427759	250468.10	2026-05-03 06:30:55
191	4253857612488245	7504429714945520	846112.76	2026-05-27 00:07:53
192	2068226289593803	4884333020521633	961890.36	2025-03-18 14:14:17
193	7188366313795421	7562694668764235	793256.66	2026-09-08 15:26:21
194	4265316267719762	3905783934171980	166070.29	2026-08-24 03:10:10
195	8032839298716593	9894818877545874	488087.87	2025-02-11 10:32:26
196	1038992020053813	5196467046957649	596531.62	2025-01-04 12:24:11
197	8229000143163782	3034484965218178	623099.51	2025-09-23 01:50:24
198	8611037787003687	2475292441078600	429598.32	2026-08-11 00:31:41
199	5631959940278586	4927754316283648	374273.51	2026-08-20 03:21:12
200	8370420264766442	3703683041021228	449678.68	2025-02-01 22:42:59
\.


--
-- TOC entry 3425 (class 2606 OID 49168)
-- Name: contribuyente_copia contribuyente_copia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contribuyente_copia
    ADD CONSTRAINT contribuyente_copia_pkey PRIMARY KEY (rfc);


--
-- TOC entry 3391 (class 2606 OID 16783)
-- Name: contribuyente contribuyente_e_firma_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contribuyente
    ADD CONSTRAINT contribuyente_e_firma_key UNIQUE (e_firma);


--
-- TOC entry 3393 (class 2606 OID 41552)
-- Name: contribuyente contribuyente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contribuyente
    ADD CONSTRAINT contribuyente_pkey PRIMARY KEY (rfc);


--
-- TOC entry 3427 (class 2606 OID 49170)
-- Name: cuenta_bancaria_copia cuenta_bancaria_copia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuenta_bancaria_copia
    ADD CONSTRAINT cuenta_bancaria_copia_pkey PRIMARY KEY (numero_cuenta);


--
-- TOC entry 3433 (class 2606 OID 57373)
-- Name: desglose_norm desglose_norm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.desglose_norm
    ADD CONSTRAINT desglose_norm_pkey PRIMARY KEY (id_reporte, renglon);


--
-- TOC entry 3429 (class 2606 OID 57358)
-- Name: entidad_norm entidad_norm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entidad_norm
    ADD CONSTRAINT entidad_norm_pkey PRIMARY KEY (id_notario);


--
-- TOC entry 3403 (class 2606 OID 41614)
-- Name: lista_bloqueados lista_bloqueados_rfc_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lista_bloqueados
    ADD CONSTRAINT lista_bloqueados_rfc_key UNIQUE (rfc);


--
-- TOC entry 3411 (class 2606 OID 16847)
-- Name: entidad_reportante llave_primaria_; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entidad_reportante
    ADD CONSTRAINT llave_primaria_ PRIMARY KEY (id_notario);


--
-- TOC entry 3409 (class 2606 OID 16842)
-- Name: bien llave_primaria_bien; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bien
    ADD CONSTRAINT llave_primaria_bien PRIMARY KEY (id_bien);


--
-- TOC entry 3407 (class 2606 OID 41630)
-- Name: cuenta_bancaria llave_primaria_cuenta; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuenta_bancaria
    ADD CONSTRAINT llave_primaria_cuenta PRIMARY KEY (numero_cuenta);


--
-- TOC entry 3405 (class 2606 OID 16820)
-- Name: lista_bloqueados llave_primaria_lista; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lista_bloqueados
    ADD CONSTRAINT llave_primaria_lista PRIMARY KEY (id_bloqueo);


--
-- TOC entry 3395 (class 2606 OID 41564)
-- Name: persona_fisica persona_fisica_curp_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona_fisica
    ADD CONSTRAINT persona_fisica_curp_key UNIQUE (curp);


--
-- TOC entry 3397 (class 2606 OID 41573)
-- Name: persona_fisica persona_fisica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona_fisica
    ADD CONSTRAINT persona_fisica_pkey PRIMARY KEY (rfc);


--
-- TOC entry 3399 (class 2606 OID 41582)
-- Name: persona_moral persona_moral_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona_moral
    ADD CONSTRAINT persona_moral_pkey PRIMARY KEY (rfc);


--
-- TOC entry 3421 (class 2606 OID 16910)
-- Name: alerta primaria_alerta; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerta
    ADD CONSTRAINT primaria_alerta PRIMARY KEY (id_alerta);


--
-- TOC entry 3401 (class 2606 OID 41606)
-- Name: telefono primaria_contribuyente; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.telefono
    ADD CONSTRAINT primaria_contribuyente PRIMARY KEY (rfc, numero);


--
-- TOC entry 3417 (class 2606 OID 16885)
-- Name: desglose primaria_desglose; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.desglose
    ADD CONSTRAINT primaria_desglose PRIMARY KEY (id_reporte, numero_renglon);


--
-- TOC entry 3423 (class 2606 OID 16920)
-- Name: expediente primaria_expediente; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expediente
    ADD CONSTRAINT primaria_expediente PRIMARY KEY (num_expediente);


--
-- TOC entry 3413 (class 2606 OID 16852)
-- Name: operacion_vulnerable primaria_operacion; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.operacion_vulnerable
    ADD CONSTRAINT primaria_operacion PRIMARY KEY (id_operacion);


--
-- TOC entry 3415 (class 2606 OID 16872)
-- Name: reporte_uif primaria_reporte; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reporte_uif
    ADD CONSTRAINT primaria_reporte PRIMARY KEY (id_reporte);


--
-- TOC entry 3419 (class 2606 OID 16895)
-- Name: transaccion primaria_transaccion; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaccion
    ADD CONSTRAINT primaria_transaccion PRIMARY KEY (id_transaccion);


--
-- TOC entry 3431 (class 2606 OID 57363)
-- Name: reporte_norm reporte_norm_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reporte_norm
    ADD CONSTRAINT reporte_norm_pkey PRIMARY KEY (id_reporte);


--
-- TOC entry 3442 (class 2606 OID 49176)
-- Name: cuenta_bancaria_copia cuenta_contribuyente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cuenta_bancaria_copia
    ADD CONSTRAINT cuenta_contribuyente FOREIGN KEY (rfc) REFERENCES public.contribuyente_copia(rfc) ON DELETE CASCADE;


--
-- TOC entry 3444 (class 2606 OID 57374)
-- Name: desglose_norm desglose_norm_id_reporte_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.desglose_norm
    ADD CONSTRAINT desglose_norm_id_reporte_fkey FOREIGN KEY (id_reporte) REFERENCES public.reporte_norm(id_reporte) ON DELETE RESTRICT;


--
-- TOC entry 3437 (class 2606 OID 16886)
-- Name: desglose foranea_desglose; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.desglose
    ADD CONSTRAINT foranea_desglose FOREIGN KEY (id_reporte) REFERENCES public.reporte_uif(id_reporte) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3438 (class 2606 OID 41706)
-- Name: transaccion foranea_destino; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaccion
    ADD CONSTRAINT foranea_destino FOREIGN KEY (cuenta_destino) REFERENCES public.cuenta_bancaria(numero_cuenta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3441 (class 2606 OID 16921)
-- Name: expediente foranea_expediente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.expediente
    ADD CONSTRAINT foranea_expediente FOREIGN KEY (id_alerta) REFERENCES public.alerta(id_alerta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3434 (class 2606 OID 16858)
-- Name: operacion_vulnerable foranea_operacion_bien; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.operacion_vulnerable
    ADD CONSTRAINT foranea_operacion_bien FOREIGN KEY (id_bien) REFERENCES public.bien(id_bien) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3435 (class 2606 OID 16863)
-- Name: operacion_vulnerable foranea_operacion_entidad; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.operacion_vulnerable
    ADD CONSTRAINT foranea_operacion_entidad FOREIGN KEY (id_notario) REFERENCES public.entidad_reportante(id_notario) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3439 (class 2606 OID 41693)
-- Name: transaccion foranea_origen; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transaccion
    ADD CONSTRAINT foranea_origen FOREIGN KEY (cuenta_origen) REFERENCES public.cuenta_bancaria(numero_cuenta) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3436 (class 2606 OID 16873)
-- Name: reporte_uif foranea_reporte; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reporte_uif
    ADD CONSTRAINT foranea_reporte FOREIGN KEY (id_notario) REFERENCES public.entidad_reportante(id_notario) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3440 (class 2606 OID 16911)
-- Name: alerta foranea_transaccion; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerta
    ADD CONSTRAINT foranea_transaccion FOREIGN KEY (id_transaccion) REFERENCES public.transaccion(id_transaccion) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3443 (class 2606 OID 57364)
-- Name: reporte_norm reporte_norm_id_notario_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reporte_norm
    ADD CONSTRAINT reporte_norm_id_notario_fkey FOREIGN KEY (id_notario) REFERENCES public.entidad_norm(id_notario) ON DELETE RESTRICT;


--
-- TOC entry 3612 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

CREATE ROLE rol_admin;
CREATE ROLE rol_app;
CREATE ROLE rol_consulta;

GRANT ALL ON SCHEMA public TO rol_admin;
GRANT USAGE ON SCHEMA public TO rol_app;
GRANT USAGE ON SCHEMA public TO rol_consulta;


--
-- TOC entry 3613 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE alerta; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.alerta TO rol_consulta;
GRANT SELECT,INSERT,UPDATE ON TABLE public.alerta TO rol_app;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.alerta TO rol_admin;


--
-- TOC entry 3614 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE bien; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.bien TO rol_consulta;
GRANT SELECT,UPDATE ON TABLE public.bien TO rol_app;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.bien TO rol_admin;


--
-- TOC entry 3615 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE contribuyente; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.contribuyente TO rol_consulta;
GRANT SELECT,INSERT,UPDATE ON TABLE public.contribuyente TO rol_app;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.contribuyente TO rol_admin;


--
-- TOC entry 3616 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE contribuyente_copia; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.contribuyente_copia TO rol_app;
GRANT SELECT ON TABLE public.contribuyente_copia TO rol_consulta;


--
-- TOC entry 3617 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE cuenta_bancaria; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.cuenta_bancaria TO rol_consulta;
GRANT SELECT,INSERT,UPDATE ON TABLE public.cuenta_bancaria TO rol_app;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.cuenta_bancaria TO rol_admin;


--
-- TOC entry 3618 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE cuenta_bancaria_copia; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.cuenta_bancaria_copia TO rol_app;
GRANT SELECT ON TABLE public.cuenta_bancaria_copia TO rol_consulta;


--
-- TOC entry 3619 (class 0 OID 0)
-- Dependencies: 227
-- Name: TABLE desglose; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.desglose TO rol_consulta;
GRANT SELECT,INSERT,UPDATE ON TABLE public.desglose TO rol_app;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.desglose TO rol_admin;


--
-- TOC entry 3620 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE desglose_norm; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.desglose_norm TO rol_app;
GRANT SELECT ON TABLE public.desglose_norm TO rol_consulta;


--
-- TOC entry 3621 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE entidad_norm; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.entidad_norm TO rol_app;
GRANT SELECT ON TABLE public.entidad_norm TO rol_consulta;


--
-- TOC entry 3622 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE entidad_reportante; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.entidad_reportante TO rol_consulta;
GRANT SELECT,INSERT,UPDATE ON TABLE public.entidad_reportante TO rol_app;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.entidad_reportante TO rol_admin;


--
-- TOC entry 3623 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE expediente; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.expediente TO rol_consulta;
GRANT SELECT,INSERT,UPDATE ON TABLE public.expediente TO rol_app;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.expediente TO rol_admin;


--
-- TOC entry 3624 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE lista_bloqueados; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.lista_bloqueados TO rol_consulta;
GRANT SELECT,INSERT,UPDATE ON TABLE public.lista_bloqueados TO rol_app;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.lista_bloqueados TO rol_admin;


--
-- TOC entry 3625 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE operacion_vulnerable; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.operacion_vulnerable TO rol_consulta;
GRANT SELECT,INSERT,UPDATE ON TABLE public.operacion_vulnerable TO rol_app;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.operacion_vulnerable TO rol_admin;


--
-- TOC entry 3626 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE persona_fisica; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.persona_fisica TO rol_consulta;
GRANT SELECT,INSERT,UPDATE ON TABLE public.persona_fisica TO rol_app;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.persona_fisica TO rol_admin;


--
-- TOC entry 3627 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE persona_moral; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.persona_moral TO rol_consulta;
GRANT SELECT,INSERT,UPDATE ON TABLE public.persona_moral TO rol_app;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.persona_moral TO rol_admin;


--
-- TOC entry 3628 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE reporte_norm; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,UPDATE ON TABLE public.reporte_norm TO rol_app;
GRANT SELECT ON TABLE public.reporte_norm TO rol_consulta;


--
-- TOC entry 3629 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE reporte_uif; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.reporte_uif TO rol_consulta;
GRANT SELECT,INSERT,UPDATE ON TABLE public.reporte_uif TO rol_app;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.reporte_uif TO rol_admin;


--
-- TOC entry 3630 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE telefono; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.telefono TO rol_consulta;
GRANT SELECT,INSERT,UPDATE ON TABLE public.telefono TO rol_app;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.telefono TO rol_admin;


--
-- TOC entry 3631 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE transaccion; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.transaccion TO rol_consulta;
GRANT SELECT,INSERT,UPDATE ON TABLE public.transaccion TO rol_app;
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.transaccion TO rol_admin;


--
-- TOC entry 2139 (class 826 OID 41751)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT,INSERT,UPDATE ON TABLES TO rol_app;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON TABLES TO rol_consulta;


-- Completed on 2026-11-23 04:18:46

--
-- PostgreSQL database dump complete
--

\unrestrict P1MJ9yBFgGTk1l1HZbP8EcB27u5W8g0dS7xjrgMOMnVWeQkZmA3WssLAdbblTA3

