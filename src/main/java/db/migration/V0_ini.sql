--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4
-- Dumped by pg_dump version 16.4

-- Started on 2024-10-15 19:20:39

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5056 (class 1262 OID 16398)
-- Name: loja_java_21; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE loja_java_21 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';


ALTER DATABASE loja_java_21 OWNER TO postgres;

\connect loja_java_21

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 255 (class 1255 OID 16642)
-- Name: validachavepessoa(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validachavepessoa() RETURNS trigger
    LANGUAGE plpgsql
AS $$

declare existe integer;

begin
    existe = (select count(1) from pessoa_fisica where id = NEW.pessoa_id);
    if(existe <=0 ) then
        existe = (select count(1) from pessoa_juridica where id = NEW.pessoa_id);
        if (existe <= 0) then
            raise exception 'Não foi encontrado o ID ou PK da pessoa para realizar a associação';
        end if;
    end if;
    RETURN NEW;
end;
$$;


ALTER FUNCTION public.validachavepessoa() OWNER TO postgres;

--
-- TOC entry 256 (class 1255 OID 16643)
-- Name: validachavepessoaforn(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validachavepessoaforn() RETURNS trigger
    LANGUAGE plpgsql
AS $$

declare existe integer;

begin
    existe = (select count(1) from pessoa_fisica where id = NEW.pessoa_forn_id);
    if(existe <=0 ) then
        existe = (select count(1) from pessoa_juridica where id = NEW.pessoa_forn_id);
        if (existe <= 0) then
            raise exception 'Não foi encontrado o ID ou PK da pessoa para realizar a associação';
        end if;
    end if;
    RETURN NEW;
end;
$$;


ALTER FUNCTION public.validachavepessoaforn() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 16399)
-- Name: acesso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.acesso (
                               id bigint NOT NULL,
                               descricao character varying(255) NOT NULL
);


ALTER TABLE public.acesso OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16404)
-- Name: avaliacao_produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.avaliacao_produto (
                                          id bigint NOT NULL,
                                          descricao character varying(255) NOT NULL,
                                          nota integer NOT NULL,
                                          pessoa_id bigint NOT NULL,
                                          produto_id bigint NOT NULL
);


ALTER TABLE public.avaliacao_produto OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16409)
-- Name: categoria_produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categoria_produto (
                                          id bigint NOT NULL,
                                          nome_desc character varying(255) NOT NULL
);


ALTER TABLE public.categoria_produto OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16414)
-- Name: conta_pagar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conta_pagar (
                                    id bigint NOT NULL,
                                    data_pagamento date,
                                    data_vencimento date NOT NULL,
                                    descricao character varying(255) NOT NULL,
                                    status character varying(255) NOT NULL,
                                    valor_desconto numeric(38,2),
                                    valor_total numeric(38,2) NOT NULL,
                                    pessoa_id bigint NOT NULL,
                                    pessoa_forn_id bigint NOT NULL,
                                    CONSTRAINT conta_pagar_status_check CHECK (((status)::text = ANY ((ARRAY['COBRANCA'::character varying, 'VENCIDA'::character varying, 'ABERTA'::character varying, 'QUITADA'::character varying, 'RENEGOCIADA'::character varying])::text[])))
);


ALTER TABLE public.conta_pagar OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16422)
-- Name: conta_receber; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conta_receber (
                                      id bigint NOT NULL,
                                      data_pagamento date,
                                      data_vencimento date NOT NULL,
                                      descricao character varying(255) NOT NULL,
                                      status character varying(255) NOT NULL,
                                      valor_desconto numeric(38,2),
                                      valor_total numeric(38,2) NOT NULL,
                                      pessoa_id bigint NOT NULL,
                                      CONSTRAINT conta_receber_status_check CHECK (((status)::text = ANY ((ARRAY['COBRANCA'::character varying, 'VENCIDA'::character varying, 'ABERTA'::character varying, 'QUITADA'::character varying])::text[])))
);


ALTER TABLE public.conta_receber OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16430)
-- Name: cupom_desconto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cupom_desconto (
                                       id bigint NOT NULL,
                                       codigo_desc character varying(255) NOT NULL,
                                       data_validade date,
                                       valor_porcentagem_desc numeric(38,2),
                                       valor_real_desc numeric(38,2)
);


ALTER TABLE public.cupom_desconto OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16435)
-- Name: endereco; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.endereco (
                                 id bigint NOT NULL,
                                 bairro character varying(255) NOT NULL,
                                 cep character varying(255) NOT NULL,
                                 cidade character varying(255) NOT NULL,
                                 complemento character varying(255),
                                 logradouro character varying(255) NOT NULL,
                                 numero character varying(255) NOT NULL,
                                 tipo_endereco character varying(255) NOT NULL,
                                 uf character varying(255) NOT NULL,
                                 pessoa_id bigint NOT NULL,
                                 CONSTRAINT endereco_tipo_endereco_check CHECK (((tipo_endereco)::text = ANY ((ARRAY['COBRANCA'::character varying, 'ENTREGA'::character varying])::text[])))
);


ALTER TABLE public.endereco OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16443)
-- Name: forma_pagamento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.forma_pagamento (
                                        id bigint NOT NULL,
                                        descricao character varying(255) NOT NULL
);


ALTER TABLE public.forma_pagamento OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16448)
-- Name: imagem_produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.imagem_produto (
                                       id bigint NOT NULL,
                                       imagem_miniatura text NOT NULL,
                                       imagem_original text NOT NULL,
                                       produto_id bigint NOT NULL
);


ALTER TABLE public.imagem_produto OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16455)
-- Name: item_venda_loja; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_venda_loja (
                                        id bigint NOT NULL,
                                        quantidade double precision NOT NULL,
                                        produto_id bigint NOT NULL,
                                        venda_compra_loja_virtual_id bigint NOT NULL
);


ALTER TABLE public.item_venda_loja OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16460)
-- Name: marca_produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.marca_produto (
                                      id bigint NOT NULL,
                                      nome_desc character varying(255) NOT NULL
);


ALTER TABLE public.marca_produto OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16465)
-- Name: nota_fiscal_compra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nota_fiscal_compra (
                                           id bigint NOT NULL,
                                           data_compra date NOT NULL,
                                           descricao_obs character varying(255),
                                           numero_nota character varying(255) NOT NULL,
                                           serie_nota character varying(255) NOT NULL,
                                           valor_desconto numeric(38,2),
                                           valor_icms numeric(38,2) NOT NULL,
                                           valor_total numeric(38,2) NOT NULL,
                                           conta_pagar_id bigint NOT NULL,
                                           pessoa_id bigint NOT NULL
);


ALTER TABLE public.nota_fiscal_compra OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16472)
-- Name: nota_fiscal_venda; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nota_fiscal_venda (
                                          id bigint NOT NULL,
                                          numero_nota character varying(255) NOT NULL,
                                          pdf text NOT NULL,
                                          serie character varying(255) NOT NULL,
                                          tipo character varying(255) NOT NULL,
                                          xml text NOT NULL,
                                          venda_compra_loja_virtual_id bigint NOT NULL
);


ALTER TABLE public.nota_fiscal_venda OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 16479)
-- Name: nota_item_produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nota_item_produto (
                                          id bigint NOT NULL,
                                          quantidade double precision NOT NULL,
                                          nota_fiscal_compra_id bigint NOT NULL,
                                          produto_id bigint NOT NULL
);


ALTER TABLE public.nota_item_produto OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16484)
-- Name: pessoa_fisica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pessoa_fisica (
                                      id bigint NOT NULL,
                                      email character varying(255) NOT NULL,
                                      nome character varying(255) NOT NULL,
                                      telefone character varying(255) NOT NULL,
                                      cpf character varying(255) NOT NULL,
                                      data_nascimento date
);


ALTER TABLE public.pessoa_fisica OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 16491)
-- Name: pessoa_juridica; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pessoa_juridica (
                                        id bigint NOT NULL,
                                        email character varying(255) NOT NULL,
                                        nome character varying(255) NOT NULL,
                                        telefone character varying(255) NOT NULL,
                                        categoria character varying(255),
                                        cnpj character varying(255) NOT NULL,
                                        inscricao_estadual character varying(255) NOT NULL,
                                        inscricao_municipal character varying(255),
                                        nome_fantasia character varying(255) NOT NULL,
                                        razao_social character varying(255) NOT NULL
);


ALTER TABLE public.pessoa_juridica OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16498)
-- Name: produto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produto (
                                id bigint NOT NULL,
                                qtd_alerta_estoque integer,
                                qtd_estoque integer NOT NULL,
                                alerta_qtde_estoque boolean,
                                altura double precision NOT NULL,
                                ativo boolean NOT NULL,
                                descricao text NOT NULL,
                                largura double precision NOT NULL,
                                link_youtube character varying(255),
                                nome character varying(255) NOT NULL,
                                peso double precision NOT NULL,
                                profundidade double precision NOT NULL,
                                qtd_clique integer NOT NULL,
                                tipo_unidade character varying(255) NOT NULL,
                                valor_venda numeric(38,2) NOT NULL
);


ALTER TABLE public.produto OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 16535)
-- Name: seq_acesso; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_acesso
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_acesso OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16536)
-- Name: seq_avaliacao_produto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_avaliacao_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_avaliacao_produto OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 16537)
-- Name: seq_categoria_produto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_categoria_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_categoria_produto OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16538)
-- Name: seq_conta_pagar; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_conta_pagar
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_conta_pagar OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 16539)
-- Name: seq_conta_receber; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_conta_receber
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_conta_receber OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16540)
-- Name: seq_cupom_desconto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_cupom_desconto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_cupom_desconto OWNER TO postgres;

--
-- TOC entry 242 (class 1259 OID 16541)
-- Name: seq_endereco; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_endereco
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_endereco OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 16542)
-- Name: seq_forma_pagamento; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_forma_pagamento
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_forma_pagamento OWNER TO postgres;

--
-- TOC entry 244 (class 1259 OID 16543)
-- Name: seq_imagem_produto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_imagem_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_imagem_produto OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 16544)
-- Name: seq_item_venda_loja; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_item_venda_loja
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_item_venda_loja OWNER TO postgres;

--
-- TOC entry 246 (class 1259 OID 16545)
-- Name: seq_marca_produto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_marca_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_marca_produto OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 16546)
-- Name: seq_nota_fiscal_compra; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_nota_fiscal_compra
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_nota_fiscal_compra OWNER TO postgres;

--
-- TOC entry 248 (class 1259 OID 16547)
-- Name: seq_nota_fiscal_venda; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_nota_fiscal_venda
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_nota_fiscal_venda OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 16548)
-- Name: seq_nota_item_produto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_nota_item_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_nota_item_produto OWNER TO postgres;

--
-- TOC entry 250 (class 1259 OID 16549)
-- Name: seq_pessoa; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_pessoa
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_pessoa OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 16550)
-- Name: seq_produto; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_produto OWNER TO postgres;

--
-- TOC entry 252 (class 1259 OID 16551)
-- Name: seq_status_rastreio; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_status_rastreio
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_status_rastreio OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 16552)
-- Name: seq_usuario; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_usuario
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_usuario OWNER TO postgres;

--
-- TOC entry 254 (class 1259 OID 16553)
-- Name: seq_venda_compra_loja_virtual; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seq_venda_compra_loja_virtual
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_venda_compra_loja_virtual OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 16505)
-- Name: status_rastreio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.status_rastreio (
                                        id bigint NOT NULL,
                                        centro_distribuicao character varying(255),
                                        cidade character varying(255),
                                        estado character varying(255),
                                        status character varying(255),
                                        venda_compra_loja_virtual_id bigint NOT NULL
);


ALTER TABLE public.status_rastreio OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16512)
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
                                id bigint NOT NULL,
                                data_atual_senha date NOT NULL,
                                login character varying(255) NOT NULL,
                                senha character varying(255) NOT NULL,
                                pessoa_id bigint NOT NULL
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 16519)
-- Name: usuario_acesso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario_acesso (
                                       usuario_id bigint NOT NULL,
                                       acesso_id bigint NOT NULL
);


ALTER TABLE public.usuario_acesso OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16522)
-- Name: venda_compra_loja_virtual; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.venda_compra_loja_virtual (
                                                  id bigint NOT NULL,
                                                  data_entrega date NOT NULL,
                                                  data_venda date NOT NULL,
                                                  dia_entrega integer NOT NULL,
                                                  valor_desconto numeric(38,2),
                                                  valor_frete numeric(38,2) NOT NULL,
                                                  valor_total numeric(38,2) NOT NULL,
                                                  cupom_desconto_id bigint NOT NULL,
                                                  endereco_cobranca_id bigint NOT NULL,
                                                  endereco_entrega_id bigint NOT NULL,
                                                  forma_pagamento_id bigint NOT NULL,
                                                  nota_fiscal_venda_id bigint NOT NULL,
                                                  pessoa_id bigint NOT NULL
);


ALTER TABLE public.venda_compra_loja_virtual OWNER TO postgres;

--
-- TOC entry 5011 (class 0 OID 16399)
-- Dependencies: 215
-- Data for Name: acesso; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5012 (class 0 OID 16404)
-- Dependencies: 216
-- Data for Name: avaliacao_produto; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5013 (class 0 OID 16409)
-- Dependencies: 217
-- Data for Name: categoria_produto; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5014 (class 0 OID 16414)
-- Dependencies: 218
-- Data for Name: conta_pagar; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5015 (class 0 OID 16422)
-- Dependencies: 219
-- Data for Name: conta_receber; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5016 (class 0 OID 16430)
-- Dependencies: 220
-- Data for Name: cupom_desconto; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5017 (class 0 OID 16435)
-- Dependencies: 221
-- Data for Name: endereco; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5018 (class 0 OID 16443)
-- Dependencies: 222
-- Data for Name: forma_pagamento; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5019 (class 0 OID 16448)
-- Dependencies: 223
-- Data for Name: imagem_produto; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5020 (class 0 OID 16455)
-- Dependencies: 224
-- Data for Name: item_venda_loja; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5021 (class 0 OID 16460)
-- Dependencies: 225
-- Data for Name: marca_produto; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5022 (class 0 OID 16465)
-- Dependencies: 226
-- Data for Name: nota_fiscal_compra; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5023 (class 0 OID 16472)
-- Dependencies: 227
-- Data for Name: nota_fiscal_venda; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5024 (class 0 OID 16479)
-- Dependencies: 228
-- Data for Name: nota_item_produto; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5025 (class 0 OID 16484)
-- Dependencies: 229
-- Data for Name: pessoa_fisica; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5026 (class 0 OID 16491)
-- Dependencies: 230
-- Data for Name: pessoa_juridica; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5027 (class 0 OID 16498)
-- Dependencies: 231
-- Data for Name: produto; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5028 (class 0 OID 16505)
-- Dependencies: 232
-- Data for Name: status_rastreio; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5029 (class 0 OID 16512)
-- Dependencies: 233
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5030 (class 0 OID 16519)
-- Dependencies: 234
-- Data for Name: usuario_acesso; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5031 (class 0 OID 16522)
-- Dependencies: 235
-- Data for Name: venda_compra_loja_virtual; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 236
-- Name: seq_acesso; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_acesso', 1, false);


--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 237
-- Name: seq_avaliacao_produto; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_avaliacao_produto', 1, false);


--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 238
-- Name: seq_categoria_produto; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_categoria_produto', 1, false);


--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 239
-- Name: seq_conta_pagar; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_conta_pagar', 1, false);


--
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 240
-- Name: seq_conta_receber; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_conta_receber', 1, false);


--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 241
-- Name: seq_cupom_desconto; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_cupom_desconto', 1, false);


--
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 242
-- Name: seq_endereco; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_endereco', 1, false);


--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 243
-- Name: seq_forma_pagamento; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_forma_pagamento', 1, false);


--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 244
-- Name: seq_imagem_produto; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_imagem_produto', 1, false);


--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 245
-- Name: seq_item_venda_loja; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_item_venda_loja', 1, false);


--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 246
-- Name: seq_marca_produto; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_marca_produto', 1, false);


--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 247
-- Name: seq_nota_fiscal_compra; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_nota_fiscal_compra', 1, false);


--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 248
-- Name: seq_nota_fiscal_venda; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_nota_fiscal_venda', 1, false);


--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 249
-- Name: seq_nota_item_produto; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_nota_item_produto', 1, false);


--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 250
-- Name: seq_pessoa; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_pessoa', 1, false);


--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 251
-- Name: seq_produto; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_produto', 1, false);


--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 252
-- Name: seq_status_rastreio; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_status_rastreio', 1, false);


--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 253
-- Name: seq_usuario; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_usuario', 1, false);


--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 254
-- Name: seq_venda_compra_loja_virtual; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seq_venda_compra_loja_virtual', 1, false);


--
-- TOC entry 4792 (class 2606 OID 16403)
-- Name: acesso acesso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.acesso
    ADD CONSTRAINT acesso_pkey PRIMARY KEY (id);


--
-- TOC entry 4794 (class 2606 OID 16408)
-- Name: avaliacao_produto avaliacao_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avaliacao_produto
    ADD CONSTRAINT avaliacao_produto_pkey PRIMARY KEY (id);


--
-- TOC entry 4796 (class 2606 OID 16413)
-- Name: categoria_produto categoria_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_produto
    ADD CONSTRAINT categoria_produto_pkey PRIMARY KEY (id);


--
-- TOC entry 4798 (class 2606 OID 16421)
-- Name: conta_pagar conta_pagar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conta_pagar
    ADD CONSTRAINT conta_pagar_pkey PRIMARY KEY (id);


--
-- TOC entry 4800 (class 2606 OID 16429)
-- Name: conta_receber conta_receber_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conta_receber
    ADD CONSTRAINT conta_receber_pkey PRIMARY KEY (id);


--
-- TOC entry 4802 (class 2606 OID 16434)
-- Name: cupom_desconto cupom_desconto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cupom_desconto
    ADD CONSTRAINT cupom_desconto_pkey PRIMARY KEY (id);


--
-- TOC entry 4804 (class 2606 OID 16442)
-- Name: endereco endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (id);


--
-- TOC entry 4806 (class 2606 OID 16447)
-- Name: forma_pagamento forma_pagamento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.forma_pagamento
    ADD CONSTRAINT forma_pagamento_pkey PRIMARY KEY (id);


--
-- TOC entry 4808 (class 2606 OID 16454)
-- Name: imagem_produto imagem_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagem_produto
    ADD CONSTRAINT imagem_produto_pkey PRIMARY KEY (id);


--
-- TOC entry 4810 (class 2606 OID 16459)
-- Name: item_venda_loja item_venda_loja_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_venda_loja
    ADD CONSTRAINT item_venda_loja_pkey PRIMARY KEY (id);


--
-- TOC entry 4812 (class 2606 OID 16464)
-- Name: marca_produto marca_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marca_produto
    ADD CONSTRAINT marca_produto_pkey PRIMARY KEY (id);


--
-- TOC entry 4814 (class 2606 OID 16471)
-- Name: nota_fiscal_compra nota_fiscal_compra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_fiscal_compra
    ADD CONSTRAINT nota_fiscal_compra_pkey PRIMARY KEY (id);


--
-- TOC entry 4816 (class 2606 OID 16478)
-- Name: nota_fiscal_venda nota_fiscal_venda_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_fiscal_venda
    ADD CONSTRAINT nota_fiscal_venda_pkey PRIMARY KEY (id);


--
-- TOC entry 4820 (class 2606 OID 16483)
-- Name: nota_item_produto nota_item_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_item_produto
    ADD CONSTRAINT nota_item_produto_pkey PRIMARY KEY (id);


--
-- TOC entry 4822 (class 2606 OID 16490)
-- Name: pessoa_fisica pessoa_fisica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pessoa_fisica
    ADD CONSTRAINT pessoa_fisica_pkey PRIMARY KEY (id);


--
-- TOC entry 4824 (class 2606 OID 16497)
-- Name: pessoa_juridica pessoa_juridica_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pessoa_juridica
    ADD CONSTRAINT pessoa_juridica_pkey PRIMARY KEY (id);


--
-- TOC entry 4826 (class 2606 OID 16504)
-- Name: produto produto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT produto_pkey PRIMARY KEY (id);


--
-- TOC entry 4828 (class 2606 OID 16511)
-- Name: status_rastreio status_rastreio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_rastreio
    ADD CONSTRAINT status_rastreio_pkey PRIMARY KEY (id);


--
-- TOC entry 4836 (class 2606 OID 16534)
-- Name: venda_compra_loja_virtual ukc30agr0qfwruqaoymp4chk2h1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venda_compra_loja_virtual
    ADD CONSTRAINT ukc30agr0qfwruqaoymp4chk2h1 UNIQUE (nota_fiscal_venda_id);


--
-- TOC entry 4832 (class 2606 OID 16532)
-- Name: usuario_acesso ukfhwpg5wu1u5p306q8gycxn9ky; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_acesso
    ADD CONSTRAINT ukfhwpg5wu1u5p306q8gycxn9ky UNIQUE (acesso_id);


--
-- TOC entry 4818 (class 2606 OID 16528)
-- Name: nota_fiscal_venda uklwo38kb0aaxboalphfjlan8qr; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_fiscal_venda
    ADD CONSTRAINT uklwo38kb0aaxboalphfjlan8qr UNIQUE (venda_compra_loja_virtual_id);


--
-- TOC entry 4834 (class 2606 OID 16530)
-- Name: usuario_acesso unique_acesso_user; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_acesso
    ADD CONSTRAINT unique_acesso_user UNIQUE (usuario_id, acesso_id);


--
-- TOC entry 4830 (class 2606 OID 16518)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 4838 (class 2606 OID 16526)
-- Name: venda_compra_loja_virtual venda_compra_loja_virtual_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venda_compra_loja_virtual
    ADD CONSTRAINT venda_compra_loja_virtual_pkey PRIMARY KEY (id);


--
-- TOC entry 4858 (class 2620 OID 16649)
-- Name: conta_receber validachavepessoa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoa BEFORE INSERT OR UPDATE ON public.conta_receber FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 4860 (class 2620 OID 16650)
-- Name: endereco validachavepessoa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoa BEFORE INSERT OR UPDATE ON public.endereco FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 4862 (class 2620 OID 16651)
-- Name: nota_fiscal_compra validachavepessoa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoa BEFORE INSERT OR UPDATE ON public.nota_fiscal_compra FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 4864 (class 2620 OID 16652)
-- Name: usuario validachavepessoa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoa BEFORE INSERT OR UPDATE ON public.usuario FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 4866 (class 2620 OID 16653)
-- Name: venda_compra_loja_virtual validachavepessoa; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoa BEFORE INSERT OR UPDATE ON public.venda_compra_loja_virtual FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 4855 (class 2620 OID 16654)
-- Name: avaliacao_produto validachavepessoaavaliacaoproduto; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoaavaliacaoproduto BEFORE INSERT OR UPDATE ON public.avaliacao_produto FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 4856 (class 2620 OID 16655)
-- Name: conta_pagar validachavepessoacontapagar; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoacontapagar BEFORE INSERT OR UPDATE ON public.conta_pagar FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 4857 (class 2620 OID 16656)
-- Name: conta_pagar validachavepessoacontapagarpessoa_forn_id; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoacontapagarpessoa_forn_id BEFORE INSERT OR UPDATE ON public.conta_pagar FOR EACH ROW EXECUTE FUNCTION public.validachavepessoaforn();


--
-- TOC entry 4859 (class 2620 OID 16644)
-- Name: conta_receber validachavepessoaforn; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoaforn BEFORE INSERT OR UPDATE ON public.conta_receber FOR EACH ROW EXECUTE FUNCTION public.validachavepessoaforn();


--
-- TOC entry 4861 (class 2620 OID 16645)
-- Name: endereco validachavepessoaforn; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoaforn BEFORE INSERT OR UPDATE ON public.endereco FOR EACH ROW EXECUTE FUNCTION public.validachavepessoaforn();


--
-- TOC entry 4863 (class 2620 OID 16646)
-- Name: nota_fiscal_compra validachavepessoaforn; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoaforn BEFORE INSERT OR UPDATE ON public.nota_fiscal_compra FOR EACH ROW EXECUTE FUNCTION public.validachavepessoaforn();


--
-- TOC entry 4865 (class 2620 OID 16647)
-- Name: usuario validachavepessoaforn; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoaforn BEFORE INSERT OR UPDATE ON public.usuario FOR EACH ROW EXECUTE FUNCTION public.validachavepessoaforn();


--
-- TOC entry 4867 (class 2620 OID 16648)
-- Name: venda_compra_loja_virtual validachavepessoaforn; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER validachavepessoaforn BEFORE INSERT OR UPDATE ON public.venda_compra_loja_virtual FOR EACH ROW EXECUTE FUNCTION public.validachavepessoaforn();


--
-- TOC entry 4848 (class 2606 OID 16599)
-- Name: usuario_acesso acesso_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_acesso
    ADD CONSTRAINT acesso_fk FOREIGN KEY (acesso_id) REFERENCES public.acesso(id);


--
-- TOC entry 4843 (class 2606 OID 16574)
-- Name: nota_fiscal_compra conta_pagar_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_fiscal_compra
    ADD CONSTRAINT conta_pagar_fk FOREIGN KEY (conta_pagar_id) REFERENCES public.conta_pagar(id);


--
-- TOC entry 4850 (class 2606 OID 16609)
-- Name: venda_compra_loja_virtual cupom_desconto_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venda_compra_loja_virtual
    ADD CONSTRAINT cupom_desconto_fk FOREIGN KEY (cupom_desconto_id) REFERENCES public.cupom_desconto(id);


--
-- TOC entry 4851 (class 2606 OID 16614)
-- Name: venda_compra_loja_virtual endereco_cobranca_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venda_compra_loja_virtual
    ADD CONSTRAINT endereco_cobranca_fk FOREIGN KEY (endereco_cobranca_id) REFERENCES public.endereco(id);


--
-- TOC entry 4852 (class 2606 OID 16619)
-- Name: venda_compra_loja_virtual endereco_entrega_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venda_compra_loja_virtual
    ADD CONSTRAINT endereco_entrega_fk FOREIGN KEY (endereco_entrega_id) REFERENCES public.endereco(id);


--
-- TOC entry 4853 (class 2606 OID 16624)
-- Name: venda_compra_loja_virtual forma_pagamento_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venda_compra_loja_virtual
    ADD CONSTRAINT forma_pagamento_fk FOREIGN KEY (forma_pagamento_id) REFERENCES public.forma_pagamento(id);


--
-- TOC entry 4845 (class 2606 OID 16584)
-- Name: nota_item_produto nota_fiscal_compra_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_item_produto
    ADD CONSTRAINT nota_fiscal_compra_fk FOREIGN KEY (nota_fiscal_compra_id) REFERENCES public.nota_fiscal_compra(id);


--
-- TOC entry 4854 (class 2606 OID 16629)
-- Name: venda_compra_loja_virtual nota_fiscal_venda_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.venda_compra_loja_virtual
    ADD CONSTRAINT nota_fiscal_venda_fk FOREIGN KEY (nota_fiscal_venda_id) REFERENCES public.nota_fiscal_venda(id);


--
-- TOC entry 4839 (class 2606 OID 16554)
-- Name: avaliacao_produto produto_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avaliacao_produto
    ADD CONSTRAINT produto_fk FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 4840 (class 2606 OID 16559)
-- Name: imagem_produto produto_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagem_produto
    ADD CONSTRAINT produto_fk FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 4841 (class 2606 OID 16564)
-- Name: item_venda_loja produto_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_venda_loja
    ADD CONSTRAINT produto_fk FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 4846 (class 2606 OID 16589)
-- Name: nota_item_produto produto_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_item_produto
    ADD CONSTRAINT produto_fk FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 4849 (class 2606 OID 16604)
-- Name: usuario_acesso usuario_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario_acesso
    ADD CONSTRAINT usuario_fk FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- TOC entry 4842 (class 2606 OID 16569)
-- Name: item_venda_loja venda_compra_loja_virtual_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_venda_loja
    ADD CONSTRAINT venda_compra_loja_virtual_fk FOREIGN KEY (venda_compra_loja_virtual_id) REFERENCES public.venda_compra_loja_virtual(id);


--
-- TOC entry 4844 (class 2606 OID 16579)
-- Name: nota_fiscal_venda venda_compra_loja_virtual_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_fiscal_venda
    ADD CONSTRAINT venda_compra_loja_virtual_fk FOREIGN KEY (venda_compra_loja_virtual_id) REFERENCES public.venda_compra_loja_virtual(id);


--
-- TOC entry 4847 (class 2606 OID 16594)
-- Name: status_rastreio venda_compra_loja_virtual_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.status_rastreio
    ADD CONSTRAINT venda_compra_loja_virtual_fk FOREIGN KEY (venda_compra_loja_virtual_id) REFERENCES public.venda_compra_loja_virtual(id);


-- Completed on 2024-10-15 19:20:39

--
-- PostgreSQL database dump complete
--

