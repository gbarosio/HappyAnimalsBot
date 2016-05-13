--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: ha-rw; Tablespace: 
--

CREATE TABLE accounts (
    id integer NOT NULL,
    type character varying(20),
    username character varying(255),
    created timestamp without time zone DEFAULT '2016-05-13 08:43:07.727763'::timestamp without time zone
);


ALTER TABLE public.accounts OWNER TO "ha-rw";

--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: ha-rw
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounts_id_seq OWNER TO "ha-rw";

--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ha-rw
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: animals; Type: TABLE; Schema: public; Owner: ha-rw; Tablespace: 
--

CREATE TABLE animals (
    id integer NOT NULL,
    name character varying(255),
    hashtag character varying(255),
    wikipedia character varying(255),
    created timestamp without time zone DEFAULT '2016-05-13 08:47:40.042229'::timestamp without time zone
);


ALTER TABLE public.animals OWNER TO "ha-rw";

--
-- Name: animals_id_seq; Type: SEQUENCE; Schema: public; Owner: ha-rw
--

CREATE SEQUENCE animals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.animals_id_seq OWNER TO "ha-rw";

--
-- Name: animals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ha-rw
--

ALTER SEQUENCE animals_id_seq OWNED BY animals.id;


--
-- Name: followers; Type: TABLE; Schema: public; Owner: ha-rw; Tablespace: 
--

CREATE TABLE followers (
    id integer NOT NULL,
    account_id integer,
    follower_id integer,
    created timestamp without time zone DEFAULT '2016-05-13 08:44:49.555464'::timestamp without time zone
);


ALTER TABLE public.followers OWNER TO "ha-rw";

--
-- Name: followers_id_seq; Type: SEQUENCE; Schema: public; Owner: ha-rw
--

CREATE SEQUENCE followers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.followers_id_seq OWNER TO "ha-rw";

--
-- Name: followers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ha-rw
--

ALTER SEQUENCE followers_id_seq OWNED BY followers.id;


--
-- Name: quotes; Type: TABLE; Schema: public; Owner: ha-rw; Tablespace: 
--

CREATE TABLE quotes (
    id integer NOT NULL,
    animal_id integer,
    status boolean DEFAULT true,
    post text,
    created timestamp without time zone DEFAULT '2016-05-13 08:52:39.056919'::timestamp without time zone
);


ALTER TABLE public.quotes OWNER TO "ha-rw";

--
-- Name: quotes_id_seq; Type: SEQUENCE; Schema: public; Owner: ha-rw
--

CREATE SEQUENCE quotes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotes_id_seq OWNER TO "ha-rw";

--
-- Name: quotes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: ha-rw
--

ALTER SEQUENCE quotes_id_seq OWNED BY quotes.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ha-rw
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ha-rw
--

ALTER TABLE ONLY animals ALTER COLUMN id SET DEFAULT nextval('animals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ha-rw
--

ALTER TABLE ONLY followers ALTER COLUMN id SET DEFAULT nextval('followers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: ha-rw
--

ALTER TABLE ONLY quotes ALTER COLUMN id SET DEFAULT nextval('quotes_id_seq'::regclass);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: ha-rw
--

COPY accounts (id, type, username, created) FROM stdin;
1	twitter	guitarre_ar	2016-05-13 08:43:07.727763
\.


--
-- Name: accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ha-rw
--

SELECT pg_catalog.setval('accounts_id_seq', 1, true);


--
-- Data for Name: animals; Type: TABLE DATA; Schema: public; Owner: ha-rw
--

COPY animals (id, name, hashtag, wikipedia, created) FROM stdin;
1	Shark	#sharks	https://en.wikipedia.org/wiki/Shark	2016-05-13 08:47:40.042229
\.


--
-- Name: animals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ha-rw
--

SELECT pg_catalog.setval('animals_id_seq', 1, true);


--
-- Data for Name: followers; Type: TABLE DATA; Schema: public; Owner: ha-rw
--

COPY followers (id, account_id, follower_id, created) FROM stdin;
\.


--
-- Name: followers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ha-rw
--

SELECT pg_catalog.setval('followers_id_seq', 1, false);


--
-- Data for Name: quotes; Type: TABLE DATA; Schema: public; Owner: ha-rw
--

COPY quotes (id, animal_id, status, post, created) FROM stdin;
1	1	f	Have you ever heard of a shark enjoying a coffee?	2016-05-13 08:52:39.056919
\.


--
-- Name: quotes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: ha-rw
--

SELECT pg_catalog.setval('quotes_id_seq', 1, true);


--
-- Name: public; Type: ACL; Schema: -; Owner: gbarosio
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM gbarosio;
GRANT ALL ON SCHEMA public TO gbarosio;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

